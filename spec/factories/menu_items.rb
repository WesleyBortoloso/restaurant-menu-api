FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "#{Faker::Food.dish} #{n}" }
    description { Faker::Food.description }
    price { Faker::Commerce.price(range: 5..50.0) }
  end
end
