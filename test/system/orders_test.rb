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
    assert_selector "h1", text: "Orders"
  end

  test "creating an Order" do
    visit warehouse_index_url
    click_on "Buy now", match: :first

    fill_in "Apt num", with: @order.apt_num
    fill_in "City", with: @order.city
    fill_in "Email", with: @order.email
    fill_in "First name", with: @order.first_name
    fill_in "Last name", with: @order.last_name
    fill_in "State", with: @order.state
    fill_in "Street address", with: @order.street_address
    fill_in "Zip code", with: @order.zip_code
    click_on "Checkout"

    assert_text "Order was successfully created"
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
