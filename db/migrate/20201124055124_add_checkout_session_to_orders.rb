class AddCheckoutSessionToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :checkout_session, :string
  end
end
