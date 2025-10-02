class AddRestaurantToMenuItemsAndScopedUniqueness < ActiveRecord::Migration[7.1]
  def change
    add_reference :menu_items, :restaurant, null: false, foreign_key: true

    remove_index :menu_items, :name

    add_index :menu_items, [:restaurant_id, :name], unique: true
  end
end
