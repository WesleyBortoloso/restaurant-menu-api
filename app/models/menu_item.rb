class MenuItem < ApplicationRecord
  has_many :menu_menu_items, dependent: :destroy 
  has_many :menus, through: :menu_menu_items

  validates :name, presence: true, uniqueness: true
  validates :price,  presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :menus_must_belong_to_same_restaurant

  private

   def menus_must_belong_to_same_restaurant
    restaurant_ids = menus.pluck(:restaurant_id).uniq
    return if restaurant_ids.size <= 1

    errors.add(:menus, "must belong to the same restaurant")
  end
end
