require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    @order = orders(:one)
    @admin = admins(:one)
  end

  test "visiting the index" do
    sign_in @admin
    visit orders_url
    assert_selector "h3", text: "Orders"
  end

  test "successful order & payment flow" do
    visit warehouse_index_url
    click_on "Buy now", match: :first

    assert_text "New Order"

    fill_in "First name", with: "Tester"
    fill_in "Last name", with: "McTest"
    fill_in "Street address", with: "123 System Test Lane"
    fill_in "City", with: "Capybara"
    fill_in "State", with: "System Test"
    fill_in "Zip code", with: "12345"
    fill_in "Email", with: "test@example.com"
    click_on "Continue to Payment"

    assert_text "test@example.com", wait: 5
    fill_in "cardNumber", with: "4242424242424242"
    fill_in "cardExpiry", with: "424"
    fill_in "cardCvc", with: "424"
    fill_in "billingName", with: "Tester McTest"
    fill_in "billingPostalCode", with: "12345"
    click_on "Pay"

    assert_text "paid: true", wait: 5
    
  end

  test "destroying an Order" do
    sign_in @admin
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end
end
