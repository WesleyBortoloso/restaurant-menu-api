FactoryBot.define do
  factory :menu_item do
    name { "Burger" }
    price { 9 }
    description { "Delicious Burguer" }
    association :menu
  end
end
