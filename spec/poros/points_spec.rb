require 'rails_helper'

 RSpec.describe Points do
   before(:each) do
     attr = {
       payer: "DANNON",
       points: 300,
       timestamp: "2022-10-31T10:00:00Z"
     }
     attr2 = {
       payer: "UNILEVER",
       points: 200,
       timestamp: "2022-10-31T11:00:00Z"
     }
     attr3 = {
       payer: "DANNON",
       points: -200,
       timestamp: "2022-10-31T15:00:00Z"
     }
     attr4 = {
       payer: "MILLER COORS",
       points: 10000,
       timestamp: "2022-11-02T14:00:00Z"
     }
     attr5 = {
       payer: "DANNON",
       points: 1000,
       timestamp: "2022-11-01T14:00:00Z"
     }

     @points = Points.new(attr)
     @points2 = Points.new(attr2)
     @points3 = Points.new(attr3)
     @points4 = Points.new(attr4)
     @points5 = Points.new(attr5)
   end

   it "exists and has attributes" do
     expect(@points).to be_an_instance_of(Points)
     expect(@points.payer).to eq("DANNON")
     expect(@points.points).to eq(300)
     expect(@points.timestamp).to eq("2022-10-31T10:00:00Z")
   end

   it "can order points by transaction date" do
     unordered = [@points, @points2, @points3, @points4, @points5]
     expect(Points.order(unordered)).to eq([@points, @points2, @points3, @points5, @points4])
     expect(Points.order(unordered)).to_not eq(unordered)
   end

   it "spends points" do
     expect(@points.spend(@points.points)).to eq(-300)
     expect(@points3.spend(@points3.points)).to eq(200)
   end

   it "total spent" do
     unordered = [@points, @points2, @points3, @points4, @points5]
     result = {"DANNON" => -800, "UNILEVER" => -200}
     transactions = Points.order(unordered)
     expect(@points.total_spent(1000, unordered)).to eq(result)
   end
 end
