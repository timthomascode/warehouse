require 'test_helper'

class WarehouseTest < ActionDispatch::IntegrationTest

  test "index page updates when another session begins a new order" do
    @available_ware = wares(:available)
    get warehouse_index_url
    assert_select 'div',  @available_ware.name

    open_session do |other_session|
      other_session.get start_order_url, params: { ware_id: @available_ware.id }
    end

    assert_select 'div',  @available_ware.name, false
  end
end
