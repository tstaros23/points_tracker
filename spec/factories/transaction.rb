FactoryBot.define do
  factory :transaction do
    payer { Faker::Company.name }
    points { Faker::Number.number(digits: 5) }
  end
end
