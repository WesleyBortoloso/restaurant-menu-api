FactoryBot.define do
  factory :pricing do
    association :menu
    association :menu_item
    price { 9.99 }
  end
end