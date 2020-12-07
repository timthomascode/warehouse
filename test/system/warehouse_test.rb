require "application_system_test_case"

class WarehouseTest < ApplicationSystemTestCase
  test "index page lists available wares" do
    visit root_url
    assert_text wares(:silver_ring).name
  end
end
