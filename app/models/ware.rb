class Ware < ApplicationRecord
  include ActionView::Helpers
  enum status: { available: "available", processing: "processing", sold: "sold" }

  def price
    number_to_currency(price_cents / 100.0)
  end
end
