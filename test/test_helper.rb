ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here... 
  def paid_order_count
    Order.where(paid: true).count
  end

  def sold_ware_count
    Ware.where(status: :sold).count
  end

  def order_count
    Order.count
  end

  def available_ware_count
    Ware.where(status: :available).count
  end
end
