require "application_system_test_case"

class WarehouseTest < ApplicationSystemTestCase
  test "index page lists available wares" do
    visit root_url
    assert_text wares(:available).name
  end
end
