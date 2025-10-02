class MenuItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :created_at

  has_many :menus
  has_many :pricings
  belongs_to :restaurant
end
