require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'complete marks order paid and ware sold' do
    @order = orders(:two)
    @order.ware = wares(:silver_ring)
    @order.checkout_session = "Stripe"
    @order.save!

    assert_equal false, @order.paid?
    assert_equal false, @order.ware.sold?

    @order.complete

    assert_equal true, @order.paid?
    assert_equal true, @order.ware.sold?

  end
end
