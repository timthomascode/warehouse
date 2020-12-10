require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test 'complete marks order paid and ware sold' do
    @order = orders(:unpaid)
    assert_equal 1, paid_order_count
    assert_equal 1, sold_ware_count

    @order.complete
    assert_equal 2, paid_order_count
    assert_equal 2, sold_ware_count
  end

  test 'cancel deletes order and marks ware available' do
    @order = orders(:unpaid)
    assert_equal 2, order_count
    assert_equal 1, available_ware_count

    @order.cancel
    assert_equal 1, order_count
    assert_equal 2, available_ware_count
  end
end
