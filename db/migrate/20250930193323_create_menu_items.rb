class CreateMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 8, scale: 2, null: false

      t.timestamps
    end
  end
end
