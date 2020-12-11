require 'test_helper'

class WarehouseControllerTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper

  test "should get index" do
    get warehouse_index_url
    assert_response :success
  end
  
  test 'index does not broadcast to warehouse stream with blank session' do
    get warehouse_index_url
    assert_broadcasts 'warehouse', 0
  end

  test "index broadcasts to warehouse stream if ware in session" do
    get new_order_url, params: { ware_id: wares(:silver_ring).id }
    assert_broadcasts 'warehouse', 1
    get warehouse_index_url
    assert_broadcasts 'warehouse', 2
  end
end
