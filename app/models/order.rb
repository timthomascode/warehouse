class Order < ApplicationRecord
  belongs_to :ware
  validates :first_name, :last_name, :street_address, :city, :state, :zip_code, :email, :ware_id, :checkout_session, presence: true 

  def self.complete(order_id)
    order = Order.find(order_id)
    order.pay
    order.ware.sell
    order
  end

  def pay
    update!(paid: true)
  end
end
