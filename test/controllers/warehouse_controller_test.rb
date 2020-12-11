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
    post "/process_ware", params: { ware_id: wares(:silver_ring).id }
    get warehouse_index_url
    assert_broadcasts 'warehouse', 2
  end
end
