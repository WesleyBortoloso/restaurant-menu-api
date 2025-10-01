class MenuItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :price, :created_at

  has_many :menus
end
