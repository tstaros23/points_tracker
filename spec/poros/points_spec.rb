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
       timestamp: "2022-11-01T14:00:00Z"
     }
     attr5 = {
       payer: "DANNON",
       points: 1000,
       timestamp: "2022-11-02T14:00:00Z"
     }

     @points = Points.new(attr)
     @points2 = Points.new(attr2)
     @points3 = Points.new(attr3)
     @points4 = Points.new(attr4)
     @points5 = Points.new(attr5)
   end

   it "exists and has attributes" do
     expect(@points).to be_an_instance_of(Points)
   end
 end
