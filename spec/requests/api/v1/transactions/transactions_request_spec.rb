require 'rails_helper'

 RSpec.describe 'Transactions API' do
   it "can create a new Transaction" do
    transaction_params = {
                          "payer": "DANNON",
                          "points": 1000
                          }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/transactions", headers: headers, params: JSON.generate(transaction_params)
    created_transaction = Transaction.last
    expect(response.status).to eq(201)

    transaction_data = created_transaction = JSON.parse(response.body, symbolize_names: true)

    expect(transaction_data).to have_key(:payer)
    expect(transaction_data).to have_key(:points)
    expect(transaction_data).to have_key(:timestamp)
  end
   it "does not create a new transaction if any or all of the fields are missing" do
    headers = {"CONTENT_TYPE" => "application/json"}

    transaction_params = {
                          "payer": "DANNON",
                          "points": nil
                        }

    post "/api/v1/transactions", headers: headers, params: JSON.generate(transaction_params)

    expect(response.status).to eq(400)
    expect(Transaction.all.count).to eq(0)
    transaction_data = JSON.parse(response.body, symbolize_names: true)
    expect(transaction_data[:errors][:details]).to eq("Field missing")

    transaction_params = {
                          "payer": nil,
                          "points": 1000
                        }
    post "/api/v1/transactions", headers: headers, params: JSON.generate(transaction_params)

    expect(response.status).to eq(400)
    expect(Transaction.all.count).to eq(0)
    transaction_data = JSON.parse(response.body, symbolize_names: true)
    expect(transaction_data[:errors][:details]).to eq("Field missing")

    transaction_params = {
                          "payer": nil,
                          "points": nil
                        }
    post "/api/v1/transactions", headers: headers, params: JSON.generate(transaction_params)

    expect(response.status).to eq(400)
    expect(Transaction.all.count).to eq(0)
    transaction_data = JSON.parse(response.body, symbolize_names: true)
    expect(transaction_data[:errors][:details]).to eq("Field missing")
  end

  it "can spend reward points" do
    transaction_1 = Transaction.create!(payer: "DANNON", points: 200, created_at: '2022/10/11')
    transaction_2 = Transaction.create!(payer: "DANNON", points: -50, created_at: '2022/10/12')
    transaction_3 = Transaction.create!(payer: "MILLER COORS", points: 1000, created_at: '2022/10/13')
    transaction_4 = Transaction.create!(payer: "DANNON", points: 1000, created_at: '2022/10/14')

    params = {"points": 1000}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/transactions", headers: headers, params: JSON.generate(params)

    expect(response).to be_successful
    transaction_data = JSON.parse(response.body, symbolize_names: true)[0]
    expect(response.status).to eq(200)

    expect(transaction_data).to have_key(:payer)
    expect(transaction_data).to have_key(:points)
  end

  it "does not have points params when updating" do
    create_list(:transaction, 4)

    params = nil
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/transactions", headers: headers, params: JSON.generate(params)

    transaction_data = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)

    expect(transaction_data[:errors][:details]).to eq("Field missing")
  end

  it "does not have transactions when updating" do
    params = {"points": 1000}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/transactions", headers: headers, params: JSON.generate(params)

    transaction_data = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)

    expect(transaction_data[:errors][:details]).to eq("Field missing")
  end

  it "can send all point balances" do
    transaction_1 = Transaction.create!(payer: "DANNON", points: 0, created_at: '2022/10/11')
    transaction_2 = Transaction.create!(payer: "DANNON", points: 0, created_at: '2022/10/12')
    transaction_3 = Transaction.create!(payer: "MILLER COORS", points: 150, created_at: '2022/10/13')
    transaction_4 = Transaction.create!(payer: "DANNON", points: 1000, created_at: '2022/10/14')

    get '/api/v1/transactions'

    expect(response).to be_successful
    expect(response.status).to eq(200)
    transactions = JSON.parse(response.body, symbolize_names: true)

    expect(transactions.count).to eq(2)
  end
  it "renders an empty hash if there are no transactions" do

    get '/api/v1/transactions'

    expect(response).to be_successful
    expect(response.status).to eq(200)
    transactions = JSON.parse(response.body, symbolize_names: true)

    expect(transactions.count).to eq(0)
    expect(transactions.empty?).to eq(true)
  end
 end
