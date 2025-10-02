class CreatePricings < ActiveRecord::Migration[7.1]
  def change
    create_table :pricings do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.decimal :price, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :pricings, [:menu_id, :menu_item_id], unique: true
  end
end
