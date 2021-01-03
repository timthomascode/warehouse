require 'test_helper'

class WareTest < ActiveSupport::TestCase
  test "price returns US dollars" do
    ware = Ware.new(name: "Test Ware", description: "Test description for the Test Ware", price_cents: 1155)
    assert_equal "$11.55", ware.price
  end

  setup do
    @available_ware = wares(:available)
  end

  test 'mark_sold updates status to sold' do
    assert_equal 1, sold_ware_count
    assert_equal false, @available_ware.sold?

    @available_ware.mark_sold
    assert_equal 2, sold_ware_count
    assert_equal true, @available_ware.sold?
  end

  test 'process updates status of an available ware, returns true' do
    assert_equal true, @available_ware.available?

    assert_equal true, @available_ware.process

    assert_equal false, @available_ware.available?
    assert_equal true, @available_ware.processing?
  end

  test 'process returns nil if ware is not available' do
    @ware = wares(:sold)
    assert_equal false, @ware.available?

    assert_nil @ware.process
    assert_equal false, @ware.available?
    assert_equal false, @ware.processing?
  end

  test 'unprocess updates status of a processing ware, returns true' do
    @ware = wares(:processing)
    assert_equal false, @ware.available?
    assert_equal true, @ware.unprocess
    assert_equal true, @ware.available?
  end

  test 'unprocess returns nil if ware is not processing' do
    @ware = wares(:sold)
    assert_equal false, @ware.processing?
    assert_nil @ware.unprocess
    assert_equal false, @ware.available?
  end
end
