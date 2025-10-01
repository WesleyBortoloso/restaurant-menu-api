FactoryBot.define do
  factory :menu do
    name { "lunch" }
    active { true }
    association :restaurant
  end
end
