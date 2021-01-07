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
    if paid == false
      StripeAdapter.cancel_payment_intent_for(self)
      self.ware.update!(status: :available)
      self.delete
    end
  end
  
  def payment_verified?
    StripeAdapter.verify_payment_for(self)
  end

  private 

  def mark_paid
    self.update!(paid: true)
  end
end
