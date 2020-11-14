class Order < ApplicationRecord
  has_one :ware
  validates :first_name, :last_name, :street_address, :city, :state, :zip_code, :email, :ware_id, presence: true 
end
