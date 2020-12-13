# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/receipt
  def receipt
    OrderMailer.with(order_id: Order.last.id).receipt
  end

end
