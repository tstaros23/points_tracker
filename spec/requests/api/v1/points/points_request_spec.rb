require 'rails_helper'

 RSpec.describe 'Transactions API' do
   it "can create a new Transaction" do
    point_params = {
                          "payer": "DANNON",
                          "points": 1000
                          }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/points", headers: headers, params: JSON.generate(point_params)
    created_point = Point.last
    expect(response.status).to eq(201)

    point_data = created_point = JSON.parse(response.body, symbolize_names: true)

    expect(point_data).to have_key(:payer)
    expect(point_data).to have_key(:points)
    expect(point_data).to have_key(:timestamp)
  end
   it "does not create a new point if any or all of the fields are missing" do
    headers = {"CONTENT_TYPE" => "application/json"}

    point_params = {
                          "payer": "DANNON",
                          "points": nil
                        }

    post "/api/v1/points", headers: headers, params: JSON.generate(point_params)

    expect(response.status).to eq(400)
    expect(Transaction.all.count).to eq(0)
    point_data = JSON.parse(response.body, symbolize_names: true)
    expect(point_data[:errors][:details]).to eq("Field missing")

    point_params = {
                          "payer": nil,
                          "points": 1000
                        }
    post "/api/v1/points", headers: headers, params: JSON.generate(point_params)

    expect(response.status).to eq(400)
    expect(Transaction.all.count).to eq(0)
    point_data = JSON.parse(response.body, symbolize_names: true)
    expect(point_data[:errors][:details]).to eq("Field missing")

    point_params = {
                          "payer": nil,
                          "points": nil
                        }
    post "/api/v1/points", headers: headers, params: JSON.generate(point_params)

    expect(response.status).to eq(400)
    expect(Point.all.count).to eq(0)
    point_data = JSON.parse(response.body, symbolize_names: true)
    expect(point_data[:errors][:details]).to eq("Field missing")
  end

  it "can spend reward points" do
    point_1 = Transaction.create!(payer: "DANNON", points: 200, created_at: '2022/10/11')
    point_2 = Transaction.create!(payer: "DANNON", points: -50, created_at: '2022/10/12')
    point_3 = Transaction.create!(payer: "MILLER COORS", points: 1000, created_at: '2022/10/13')
    point_4 = Transaction.create!(payer: "DANNON", points: 1000, created_at: '2022/10/14')

    params = {"points": 1000}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/points", headers: headers, params: JSON.generate(params)

    expect(response).to be_successful
    point_data = JSON.parse(response.body, symbolize_names: true)[0]
    expect(response.status).to eq(200)

    expect(point_data).to have_key(:payer)
    expect(point_data).to have_key(:points)
  end

  it "does not have points params when updating" do
    create_list(:point, 4)

    params = nil
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/points", headers: headers, params: JSON.generate(params)

    point_data = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)

    expect(point_data[:errors][:details]).to eq("Field missing")
  end

  it "does not have points when updating" do
    params = {"points": 1000}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/points", headers: headers, params: JSON.generate(params)

    point_data = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)

    expect(point_data[:errors][:details]).to eq("Field missing")
  end

  it "can send all point balances" do
    point_1 = Point.create!(payer: "DANNON", points: 0, created_at: '2022/10/11')
    point_2 = Point.create!(payer: "DANNON", points: 0, created_at: '2022/10/12')
    point_3 = Point.create!(payer: "MILLER COORS", points: 150, created_at: '2022/10/13')
    point_4 = Point.create!(payer: "DANNON", points: 1000, created_at: '2022/10/14')

    get '/api/v1/points'

    expect(response).to be_successful
    expect(response.status).to eq(200)
    points = JSON.parse(response.body, symbolize_names: true)

    expect(points.count).to eq(2)
  end
  it "renders an empty hash if there are no points" do

    get '/api/v1/points'

    expect(response).to be_successful
    expect(response.status).to eq(200)
    points = JSON.parse(response.body, symbolize_names: true)

    expect(points.count).to eq(0)
    expect(points.empty?).to eq(true)
  end
 end
