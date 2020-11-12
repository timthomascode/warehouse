class Ware < ApplicationRecord
  include ActionView::Helpers

  def price
    number_to_currency(price_cents / 100.0)
  end
end
