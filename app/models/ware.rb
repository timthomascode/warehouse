class Ware < ApplicationRecord
  include ActionView::Helpers
  has_one_attached :image
  has_one :order
  validates :name, :description, :price_cents, :image, presence: true

  enum status: { available: "available", processing: "processing", sold: "sold" }

  def price
    number_to_currency(price_cents / 100.0)
  end
end
