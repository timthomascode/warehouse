require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "receipt" do
    mail = OrderMailer.with(order_id: orders(:stripe_test_order).id).receipt
    assert_equal "Warehouse Order Receipt", mail.subject
    assert_equal [ orders(:stripe_test_order).email ], mail.to
    assert_equal ["warehouse@timthomas.dev"], mail.from
    assert_match "RECEIPT FOR ORDER", mail.body.encoded
  end

end
