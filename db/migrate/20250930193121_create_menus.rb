class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
