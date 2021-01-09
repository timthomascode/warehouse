require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionCable::TestHelper
  include ActiveJob::TestHelper

  setup do
    @order = orders(:paid)
    @admin = admins(:one)
    @available_ware = wares(:available)
  end

  test 'start should save a new order with a ware' do
    assert_difference ->{ available_ware_count } => -1, ->{ order_count } => 1 do
      get start_order_url, params: { ware_id: @available_ware.id }
    end

    assert_select 'h3', "New Order"
  end

  test 'start enqueues job to cancel order' do

    assert_enqueued_jobs 0
    get start_order_url, params: { ware_id: @available_ware.id }
    assert_enqueued_jobs 1

    assert_difference 'order_count', -1 do
      perform_enqueued_jobs
    end
  end

  test 'continue should never create a new order' do
    get start_order_url, params: { ware_id: @available_ware.id }
    StripeAdapter.expects(:new_checkout_session_for).returns({ "id": "test_session_id"})
    assert_no_difference 'order_count' do
      post continue_order_url, params: { order: { order_id: Order.last.id, first_name: "Bob", last_name: "Evans", street_address: "123 Breakfast Lane", city: "Bacon", state: "Indiana", zip_code: "12345", email: "bob@example.com" } }
    end
  end

  test 'continue should save a valid order' do
    test_ware_id = @available_ware.id
    get start_order_url params: { ware_id: @available_ware.id }

    test_order = Order.where(ware_id: test_ware_id).first
    assert_equal "Silver Ring", test_order.ware.name
    assert_equal false, test_order.valid?

    StripeAdapter.expects(:new_checkout_session_for).returns({ "id": "test_session_id"})
    post continue_order_url, params: { order: { order_id: Order.last.id, first_name: "Bob", last_name: "Evans", street_address: "123 Breakfast Lane", city: "Bacon", state: "Indiana", zip_code: "12345", email: "bob@example.com" } }

    test_order.reload
    assert_equal "Bob", test_order.first_name 
    assert_equal true, test_order.valid?
  end

  test 'continue redirects to start if order is not valid' do
    get start_order_url params: { ware_id: @available_ware.id }
    post continue_order_url, params: { order: { order_id: Order.last.id, first_name: "Missing", last_name: "Street_Address", city: "Bacon", state: "Indiana", zip_code: "12345", email: "bob@example.com" } }

    assert_redirected_to start_order_url(ware_id: @available_ware.id) 
  end

  test 'success should complete order' do
    test_order = orders(:stripe_test_order)
    StripeAdapter.expects(:verify_payment_for).with(test_order).returns(true) 
    assert_difference ->{ paid_order_count } => 1, ->{ sold_ware_count } => 1 do
      get success_url, params: { session_id: test_order.stripe_session_id }
    end

    assert_response :success
  end

  test 'success sends email' do
    test_order = orders(:stripe_test_order)

    StripeAdapter.expects(:verify_payment_for).with(test_order).returns(true) 
    assert_emails 1 do
      get success_url, params: { session_id: test_order.stripe_session_id }
    end
  end

  test 'success redirects to cancel if payment not verified' do
    test_order = orders(:unpaid)
    StripeAdapter.expects(:verify_payment_for).with(test_order).returns(false) 
    get success_url, params: { session_id: test_order.stripe_session_id }
    assert_redirected_to cancel_url(stripe_session_id: test_order.stripe_session_id)
  end

  test "cancel should restart order" do
    test_order = orders(:unpaid)
    StripeAdapter.expects(:cancel_payment_intent_for).with(test_order)
    assert_difference ->{ order_count } => -1, ->{ available_ware_count } => 1 do
      get cancel_url, params: { session_id: test_order.stripe_session_id }
    end

    assert_response :redirect
    assert_redirected_to start_order_url(ware_id: test_order.ware.id)
  end

  test "should get index" do
    get orders_url
    assert_redirected_to new_admin_session_url

    sign_in @admin
    get orders_url
    assert_response :success
  end

  test 'start changes available ware to processing' do
    assert_equal false, @available_ware.processing?
    get start_order_url, params: { ware_id: @available_ware.id }

    result = Ware.find(@available_ware.id)
    assert_equal true, result.processing?
  end

  test 'start stores ware ID in the session' do
    get start_order_url, params: { ware_id: @available_ware.id }
    assert_equal @available_ware.id, session[:ware_id]
  end

  test 'start broadcasts to warehouse stream' do
    get start_order_url, params: { ware_id: @available_ware.id }
    assert_broadcasts('warehouse', 1)
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

end
