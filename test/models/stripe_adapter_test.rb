require 'test_helper'

class StripeAdapterTest < ActiveSupport::TestCase

  setup do
    @unpaid_order = orders(:unpaid)
  end

  Fake_Checkout_Session = Struct.new(:payment_status)
  
  Unpaid_Checkout_Session = { 
    "id": "cs_test_EWwXxNCVnRbDLNhVB1bWZylDMVWVs59w7w4xR5MqflUZFWWIWqXbrm5Q",
    "object": "checkout.session",
    "cancel_url": "https://example.com/cancel",
    "customer_email": nil,
    "livemode": false,
    "locale": nil,
    "metadata": {},
    "mode": "payment",
    "payment_intent": "pi_1HmXaFHRNVoJpGyr5AKwcvXN",
    "payment_method_types": ["card"],
    "payment_status": "unpaid",
    "submit_type": nil,
    "success_url": "https://example.com/success",
  }
                                                          
  test 'verify_payment_for(order) returns true if order paid' do
    paid_order = orders(:paid)
    paid_session = Fake_Checkout_Session.new("paid")
    Stripe::Checkout::Session.expects(:retrieve).returns(paid_session)
    assert_equal true, StripeAdapter.verify_payment_for(paid_order)
  end

  test 'verify_payment_for(order) returns false if order unpaid' do
    unpaid_session = Fake_Checkout_Session.new("unpaid")
    Stripe::Checkout::Session.expects(:retrieve).returns(unpaid_session)
    assert_equal false, StripeAdapter.verify_payment_for(@unpaid_order)
  end

  test 'verify_payment_for(order) returns false if checkout_session is invalid' do
    invalid_session_order = Order.new(checkout_session: "not a valid checkout session id") 
    Stripe::Checkout::Session.expects(:retrieve).raises(Stripe::InvalidRequestError)
    assert_equal false, StripeAdapter.verify_payment_for(invalid_session_order)
  end

  test 'new_checkout_session_for(order) returns a checkout session' do
    Stripe::Checkout::Session.expects(:create).returns(Unpaid_Checkout_Session)
    assert_equal Unpaid_Checkout_Session, StripeAdapter.new_checkout_session_for(@unpaid_order)
  end

  test 'new_checkout_session_for(order) returns nil if API error' do
    Stripe::Checkout::Session.expects(:create).raises(Stripe::InvalidRequestError)
    assert_nil StripeAdapter.new_checkout_session_for(@unpaid_order)
  end

  test 'new_checkout_session_for(order) returns nil if order has incomplete fields' do
    incomplete_order = Order.new
    assert_nil StripeAdapter.new_checkout_session_for(incomplete_order)
  end
 
  test 'cancel_payment_intent_for(order) returns Stripe payment_intent object' do
    Stripe::Checkout::Session.expects(:retrieve).returns(Unpaid_Checkout_Session)
    Stripe::PaymentIntent.expects(:cancel).with(Unpaid_Checkout_Session["payment_intent"]).returns({ "id": "pi_1HmXaFHRNVoJpGyr5AKwcvXN", "object": "payment_intent", "other_details": "etc" })
    assert StripeAdapter.cancel_payment_intent_for(@unpaid_order) 
  end

  test 'cancel_payment_intent_for(order) returns nil if error' do
    Stripe::Checkout::Session.expects(:retrieve).raises(Stripe::InvalidRequestError)
    assert_nil StripeAdapter.cancel_payment_intent_for(@unpaid_order)

    Stripe::Checkout::Session.expects(:retrieve).returns(Unpaid_Checkout_Session)
    Stripe::PaymentIntent.expects(:cancel).raises(Stripe::InvalidRequestError)
    
    assert_nil StripeAdapter.cancel_payment_intent_for(@unpaid_order)
  end

end
