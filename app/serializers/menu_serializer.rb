class MenuSerializer
  include JSONAPI::Serializer
  attributes :name, :active, :created_at

  has_many :menu_items
end
