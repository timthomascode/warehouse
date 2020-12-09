class Ware < ApplicationRecord
  include ActionView::Helpers
  has_one_attached :image
  has_one :order
  validates :name, :description, :price_cents, :image, :status, presence: true

  enum status: { available: "available", processing: "processing", sold: "sold" }

  def price
    number_to_currency(price_cents / 100.0)
  end

  def mark_sold
    update!(status: :sold)
  end
end
