require 'test_helper'

class WareTest < ActiveSupport::TestCase
  test "price returns US dollars" do
    ware = Ware.new(name: "Test Ware", description: "Test description for the Test Ware", price_cents: 1155)
    assert_equal "$11.55", ware.price
  end

  test 'mark_sold updates status to sold' do
    @ware = wares(:silver_ring)
    assert_equal 1, sold_ware_count
    assert_equal false, @ware.sold?

    @ware.mark_sold
    assert_equal 2, sold_ware_count
    assert_equal true, @ware.sold?
  end

  test 'process updates status of an available ware, returns true' do
    @ware = wares(:silver_ring)
    assert_equal true, @ware.available?

    assert_equal true, @ware.process

    assert_equal false, @ware.available?
    assert_equal true, @ware.processing?
  end

  test 'process returns nil if ware is not available' do
    @ware = wares(:magical_amulet)
    assert_equal false, @ware.available?

    assert_nil @ware.process
    assert_equal false, @ware.available?
    assert_equal false, @ware.processing?
  end

end
