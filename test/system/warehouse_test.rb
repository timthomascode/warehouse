require "application_system_test_case"

class WarehouseTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url
    assert_text wares(:silver_ring).name
  end
end
