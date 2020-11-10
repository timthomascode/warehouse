class CreateWares < ActiveRecord::Migration[6.0]
  def change
    create_table :wares do |t|
      t.string :name
      t.text :description
      t.decimal :price, scale: 2, precision: 5

      t.timestamps
    end
  end
end
