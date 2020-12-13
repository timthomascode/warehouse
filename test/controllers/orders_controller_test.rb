require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionCable::TestHelper

  setup do
    @order = orders(:one)
    @admin = admins(:one)
  end

  test 'success should complete order' do
    test_order = orders(:stripe_test_order)

    assert_difference ->{ paid_order_count } => 1, ->{ sold_ware_count } => 1 do
      get success_url, params: { session_id: test_order.checkout_session }
    end

    assert_response :success
  end

  test 'success sends email' do
    test_order = orders(:stripe_test_order)

    assert_emails 1 do
      get success_url, params: { session_id: test_order.checkout_session }
    end
  end

  test 'success redirects to cancel if payment not verified' do
    test_order = orders(:unpaid)
    get success_url, params: { session_id: test_order.checkout_session }
    assert_redirected_to cancel_url
  end

  test "cancel should cancel order" do
    test_order = orders(:unpaid)

    assert_difference ->{ order_count } => -1, ->{ available_ware_count } => 1 do
      get cancel_url, params: { session_id: test_order.checkout_session }
    end

    assert_response :redirect
    assert_redirected_to new_order_url(ware_id: test_order.ware_id)
  end

  test "should get index" do
    get orders_url
    assert_redirected_to new_admin_session_url

    sign_in @admin
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url, params: { ware_id: wares(:silver_ring).id }
    assert_response :success
    assert_select 'h3', 'New Order'
  end

  test 'new changes available ware to processing' do
    assert_equal false, wares(:silver_ring).processing?
    get new_order_url, params: { ware_id: wares(:silver_ring).id }

    result = Ware.find(wares(:silver_ring).id)
    assert_equal true, result.processing?
  end

  test 'new stores ware ID in the session' do
    get new_order_url, params: { ware_id: wares(:silver_ring).id }
    assert_equal wares(:silver_ring).id, session[:ware_id]
  end

  test 'new broadcasts to warehouse stream' do
    get new_order_url, params: { ware_id: wares(:silver_ring).id }
    assert_broadcasts('warehouse', 1)
  end

  test "should create order" do
    assert_difference('Order.count') do
      post orders_url, params: { order: { apt_num: @order.apt_num, city: @order.city, email: @order.email, first_name: @order.first_name, last_name: @order.last_name, state: @order.state, street_address: @order.street_address, ware_id: wares(:silver_ring).id, zip_code: @order.zip_code } }
    end 
  end

  test "should show order" do
    get order_url(@order)
    assert_redirected_to new_admin_session_url

    sign_in @admin
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_redirected_to new_admin_session_url

    sign_in @admin
    get edit_order_url(@order)
    assert_response :success
  end

  test "should destroy order" do
    assert_difference('Order.count', 0) do
      delete order_url(@order)
    end

    assert_redirected_to new_admin_session_url

    sign_in @admin
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end
    assert_redirected_to orders_url
  end
end
