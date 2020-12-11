require 'test_helper'

# Callback to remove uploaded test files from local storage
module RemoveUploadedFiles
  def after_teardown
    super
    move_test_image_blob
    remove_uploaded_files
    rebuild_test_image_blob_folders
    move_test_image_blob_back
  end

  private

  def move_test_image_blob
    FileUtils.move 'tmp/storage/12/34/123456789', 'tmp/'
  end

  def rebuild_test_image_blob_folders
    FileUtils.makedirs 'tmp/storage/12/34'
  end
  
  def remove_uploaded_files
    FileUtils.rm_rf 'tmp/storage'
  end
  
  def move_test_image_blob_back
    FileUtils.move 'tmp/123456789', 'tmp/storage/12/34'
  end
end

module ActionDispatch
  class IntegrationTest
    prepend RemoveUploadedFiles
  end
end

class WaresControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionCable::TestHelper

  setup do
    @ware = wares(:silver_ring)
  end

  test 'process_ware changes available ware status to processing' do
    post "/process_ware", params: { ware_id: @ware.id }
    ware = Ware.find(@ware.id)
    assert_equal "processing", ware.status
  end

  test 'process_ware broadcasts to warehouse channel stream' do
    post "/process_ware", params: { ware_id: @ware.id }
    assert_broadcasts('warehouse', 1)
  end

  test "process_ware stores ware's ID in the session" do
    post "/process_ware", params: { ware_id: @ware.id }
    assert_equal @ware.id, session[:processed_ware]
  end

  test 'process_ware redirects to new order page' do
    post "/process_ware", params: { ware_id: @ware.id }
    assert_redirected_to new_order_url
  end

  test "process_ware can't be called on processing and sold wares" do
    @ware.update(status: :processing)
    post "/process_ware", params: { ware_id: @ware.id }
    assert_nil session[:processed_ware]
    assert_redirected_to warehouse_index_url 
  end

  test "prevents unauthorized access" do
    # index
    get wares_url
    assert_redirected_to new_admin_session_url

    # new
    get new_ware_url
    assert_redirected_to new_admin_session_url

    # create
    assert_difference('Ware.count', 0) do
      post wares_url, params: { ware: { description: @ware.description, name: @ware.name, price_cents: @ware.price_cents } } 
    end
 
    # show
    get ware_url(@ware)
    assert_redirected_to new_admin_session_url

    # edit
    get edit_ware_url(@ware)
    assert_redirected_to new_admin_session_url

    # update
    patch ware_url(@ware), params: { ware: { description: "Test", name: @ware.name, price_cents: @ware.price_cents } }
    assert_redirected_to new_admin_session_url

    # delete
    assert_difference('Ware.count', 0) do
      delete ware_url(@ware)
    end

  end

  test "should get index" do
    sign_in admins(:one)
    get wares_url
    assert_response :success
  end

  test "should get new" do
    sign_in admins(:one)
    get new_ware_url
    assert_response :success
  end

  test "should create ware" do
    sign_in admins(:one)
    assert_difference('Ware.count') do
      post wares_url, params: { ware: { description: "A bronze sword. 24 inches long. Dark leather handle. No guard, Ruby pommel.", name: "Sword", price_cents: 40000, image: fixture_file_upload('app/assets/images/test.png', 'image/png') } }
    end

    assert_redirected_to ware_url(Ware.last)
  end

  test "should show ware" do
    sign_in admins(:one)
    get ware_url(@ware)
    assert_response :success
  end

  test "should get edit" do
    sign_in admins(:one)
    get edit_ware_url(@ware)
    assert_response :success
  end

  test "should update ware" do
    sign_in admins(:one)
    patch ware_url(@ware), params: { ware: { description: @ware.description, name: @ware.name, price_cents: @ware.price_cents } }
    assert_redirected_to ware_url(@ware)
  end

  test "should destroy available ware" do
    sign_in admins(:one)
    assert_difference('Ware.count', -1) do
      delete ware_url(wares(:silver_ring))
    end

    assert_redirected_to wares_url
    assert_equal @controller.notice, "Ware was successfully destroyed."
  end

  test "should not destroy sold and processing wares" do
    sign_in admins(:one)
    assert_difference('Ware.count', 0) do
      delete ware_url(wares(:magical_amulet)) 
    end

    assert_equal @controller.notice, "Ware cannot be deleted."
  end

end
