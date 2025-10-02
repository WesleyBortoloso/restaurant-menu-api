class MenuItem < ApplicationRecord
  belongs_to :restaurant

  has_many :pricings, dependent: :destroy
  has_many :menus, through: :pricings

  validates :name, presence: true, uniqueness: { scope: :restaurant_id }
end
