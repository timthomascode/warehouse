require 'test_helper'

class OrdersTest < ActionDispatch::IntegrationTest

  test 'two orders cannot be started with the same ware' do
    @available_ware = wares(:available)

    open_session do |other_session|
      other_session.get start_order_url, params: { ware_id: @available_ware.id }
    end

    get start_order_url, params: { ware_id: @available_ware.id }

    assert_redirected_to root_url

  end

end
