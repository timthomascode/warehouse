class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :apt_num
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :email
      t.references :ware, foreign_key: true

      t.timestamps
    end
  end
end
