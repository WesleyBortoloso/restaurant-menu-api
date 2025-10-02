class RemoveMenuItemPrice < ActiveRecord::Migration[7.1]
  def change
    remove_column :menu_items, :price
  end
end
