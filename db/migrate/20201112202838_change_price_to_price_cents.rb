class ChangePriceToPriceCents < ActiveRecord::Migration[6.0]
  def up
    add_column :wares, :price_cents, :integer
    wares = Ware.all
    wares.each do |ware| 
      ware.price_cents = (ware.price * 100).to_i
      ware.save
    end
    remove_column :wares, :price
  end

  def down
    add_column :wares, :price, :decimal, precision: 5, scale: 2
    wares = Ware.all
    wares.each do |ware| 
      ware.price = ware.price_cents / 100.0
      ware.save
    end
    remove_column :wares, :price_cents
  end
end
