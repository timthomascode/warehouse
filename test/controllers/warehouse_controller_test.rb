require 'test_helper'

class WarehouseControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get warehouse_index_url
    assert_response :success
  end

end
