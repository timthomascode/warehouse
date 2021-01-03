class Order < ApplicationRecord
  belongs_to :ware
  validates :first_name, :last_name, :street_address, :city, :state, :zip_code, :email, :ware_id, presence: true 

  def complete
    if payment_verified?
      self.mark_paid
      self.ware.mark_sold
    end
  end

  def cancel
    #TODO: if checkout session payment intent is valid, cancel the payment intent through stripe api.
    #TODO: verify that order is not already paid. do not allow for paid orders to be canceled.
    self.ware.update!(status: :available)
    self.delete
  end
  
  def payment_verified?
    begin
      Stripe::Checkout::Session.retrieve(checkout_session).payment_status == "paid"
    rescue
      false
    end
  end

  def mark_paid
    self.update!(paid: true)
  end
end
