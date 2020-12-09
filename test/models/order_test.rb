require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "pay updates paid value to true" do
    @order = orders(:two)
    @order.ware = wares(:silver_ring)
    @order.checkout_session = "Stripe::Checkout::Session.id"

    assert_equal false, @order.paid?
    assert_equal true, @order.pay
    assert_equal true, @order.paid?
  end
end
