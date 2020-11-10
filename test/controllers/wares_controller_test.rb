require 'test_helper'

class WaresControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @ware = wares(:one)
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
      post wares_url, params: { ware: { description: @ware.description, name: @ware.name, price: @ware.price } } 
    end
 
    # show
    get ware_url(@ware)
    assert_redirected_to new_admin_session_url

    # edit
    get edit_ware_url(@ware)
    assert_redirected_to new_admin_session_url

    # update
    patch ware_url(@ware), params: { ware: { description: "Test", name: @ware.name, price: @ware.price } }
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
      post wares_url, params: { ware: { description: @ware.description, name: @ware.name, price: @ware.price } }
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
    patch ware_url(@ware), params: { ware: { description: @ware.description, name: @ware.name, price: @ware.price } }
    assert_redirected_to ware_url(@ware)
  end

  test "should destroy ware" do
    sign_in admins(:one)
    assert_difference('Ware.count', -1) do
      delete ware_url(@ware)
    end

    assert_redirected_to wares_url
  end
end
