require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'Order.complete marks order as paid and ware as sold' do
    @order = orders(:two)
    @order.ware = wares(:silver_ring)
    @order.checkout_session = "Stripe::Checkout::Session.id"
    @order.save!

    assert_equal false, @order.paid?
    assert_equal false, @order.ware.sold?

    Order.complete(@order.id)
    completed_order = Order.find(@order.id)
    
    assert_equal true, completed_order.paid?
    assert_equal true, completed_order.ware.sold?
  end

  test 'finalize marks order paid and ware sold' do
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
