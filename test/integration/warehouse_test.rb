require 'test_helper'

class WarehouseTest < ActionDispatch::IntegrationTest

  test "index page updates when another session begins a new order" do
    get warehouse_index_url
    assert_select 'div',  wares(:silver_ring).name

    open_session do |other_session|
      other_session.get start_order_url, params: { ware_id: wares(:silver_ring).id }
    end

    assert_select 'div',  wares(:silver_ring).name, false
  end
end
