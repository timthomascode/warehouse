require 'test_helper'

class WareTest < ActiveSupport::TestCase
  test "price returns US dollars" do
    ware = Ware.new(name: "Test Ware", description: "Test description for the Test Ware", price_cents: 1155)
    assert_equal "$11.55", ware.price
  end

  test 'sell updates status to sold' do
    @ware = wares(:silver_ring)
    assert_equal false, @ware.sold?
    @ware.mark_sold
    assert_equal true, @ware.sold?
  end
end
