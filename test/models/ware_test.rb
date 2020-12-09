require 'test_helper'

class WareTest < ActiveSupport::TestCase
  test "price returns US dollars" do
    ware = Ware.new(name: "Test Ware", description: "Test description for the Test Ware", price_cents: 1155)
    assert_equal "$11.55", ware.price
  end
end
