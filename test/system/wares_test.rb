require "application_system_test_case"

class WaresTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @ware = wares(:sold)
    sign_in admins(:one)
  end

  test "visiting the index" do
    visit wares_url
    assert_selector "h3", text: "Wares"
  end

  test "creating a Ware" do
    visit wares_url
    click_on "Sell Something"

    fill_in "Description", with: @ware.description
    fill_in "Name", with: @ware.name
    fill_in "Price", with: @ware.price_cents
    attach_file "Image", "app/assets/images/test.png"
    click_on "Create Ware"

    assert_text "Ware was successfully created"
    click_on "Back"
  end

  test "updating a Ware" do
    visit wares_url
    click_on "Edit", match: :first

    fill_in "Description", with: "Updated description"
    fill_in "Name", with: "Updated Name"
    fill_in "Price", with: 1500
    click_on "Update Ware"

    assert_text "Ware was successfully updated"
    click_on "Back"
  end

  test "destroying a Ware" do
    visit wares_url
    available_ware = wares(:available)
    page.accept_confirm do
      find_by_id("#{ available_ware.id }").click_on "Destroy"
    end

    assert_text "Ware was successfully destroyed"
  end
end
