require "test_helper"

class WarehouseChannelTest < ActionCable::Channel::TestCase
  test "subscribes to warehouse stream" do
    subscribe
    assert subscription.confirmed?
    assert_has_stream "warehouse"
  end
end
