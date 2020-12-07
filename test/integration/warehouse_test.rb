require 'test_helper'

class WarehouseTest < ActionDispatch::IntegrationTest

  test "index page updates when another session begins a new order" do
    get warehouse_index_url
    assert_select 'div',  wares(:silver_ring).name

    open_session do |other_session|
      other_session.get warehouse_index_url
      other_session.post "/process_ware/#{ wares(:silver_ring).id }"
    end

    assert_select 'div',  wares(:silver_ring).name, false
  end
end
