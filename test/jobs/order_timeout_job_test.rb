require 'test_helper'

class OrderTimeoutJobTest < ActiveJob::TestCase
  test "order is cancelled" do
    order_id = orders(:unpaid).id

    assert_difference ->{ order_count } => -1, ->{ available_ware_count } => 1 do
      OrderTimeoutJob.perform_now(order_id)
    end
  end
    
end
