class Order < ApplicationRecord
  belongs_to :ware
  validates :first_name, :last_name, :street_address, :city, :state, :zip_code, :email, :ware_id, :checkout_session, presence: true 

  def complete
    self.mark_paid
    self.ware.mark_sold
  end

  def cancel
    self.ware.update!(status: :available)
    self.delete
  end

  def mark_paid
    self.update!(paid: true)
  end
end
