class RemoveMenuMenuItems < ActiveRecord::Migration[7.1]
   def change
    drop_table :menu_menu_items
  end
end
