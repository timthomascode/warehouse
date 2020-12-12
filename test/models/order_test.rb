require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test 'complete marks order paid and ware sold' do
    @order = orders(:unpaid)

    assert_difference ->{ paid_order_count } => 1, ->{ sold_ware_count } => 1 do
      @order.complete
    end
  end

  test 'cancel deletes order and marks ware available' do
    @order = orders(:unpaid)
    assert_difference ->{ order_count } => -1, ->{ available_ware_count } => 1 do
      @order.cancel
    end
  end

  test 'payment_verified? returns false if payment not received by Stripe' do
    @order = orders(:unpaid)
    assert_equal false, @order.payment_verified?
  end

  test 'payment_verified? returns true if payment receieved by Stripe' do
    @order = orders(:stripe_test_order)
    assert_equal true, @order.payment_verified?
  end
end
