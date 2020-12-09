class Order < ApplicationRecord
  belongs_to :ware
  validates :first_name, :last_name, :street_address, :city, :state, :zip_code, :email, :ware_id, :checkout_session, presence: true 

  def self.complete(order_id)
    order = Order.find(order_id)
    order.mark_paid
    order.ware.mark_sold
    order
  end

  def mark_paid
    update!(paid: true)
  end
end
