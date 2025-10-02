class PricingSerializer
  include JSONAPI::Serializer
  attributes :price

  belongs_to :menu
  belongs_to :menu_item
end