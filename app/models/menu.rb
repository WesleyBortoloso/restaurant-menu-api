class Menu < ApplicationRecord
  belongs_to :restaurant

  has_many :pricings, dependent: :destroy
  has_many :menu_items, through: :pricings

  validates :name, presence: true
end
