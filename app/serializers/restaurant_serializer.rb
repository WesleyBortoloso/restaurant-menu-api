class RestaurantSerializer
  include JSONAPI::Serializer
  attributes :name, :created_at

  has_many :menus
  has_many :menu_items
end
