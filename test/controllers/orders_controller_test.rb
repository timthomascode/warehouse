require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @order = orders(:one)
    @admin = admins(:one)
  end

  test 'success should complete order' do

    test_order = Order.create!(
      first_name: "Orders",
      last_name: "#success",
      street_address: "123 Should",
      city: "Complete",
      state: "Order",
      zip_code: "12345",
      email: "success_test@example.com",
      ware: wares(:silver_ring),
      checkout_session: "success_test_checkout_session")

    assert_equal false, Order.find(test_order.id).paid?

    get "#{ success_url }?session_id=success_test_checkout_session"
    assert_response :success

    result_order = Order.find(test_order.id)
    assert_equal true, result_order.paid?
    assert_equal true, result_order.ware.sold?
  end

  test "should get index" do
    get orders_url
    assert_redirected_to new_admin_session_url

    sign_in @admin
    get orders_url
    assert_response :success
  end

  test "should get new" do
    post "/process_ware/#{ wares(:silver_ring).id }"
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post "/process_ware/#{ wares(:silver_ring).id }"
      post orders_url, params: { order: { apt_num: @order.apt_num, city: @order.city, email: @order.email, first_name: @order.first_name, last_name: @order.last_name, state: @order.state, street_address: @order.street_address, zip_code: @order.zip_code } }
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
