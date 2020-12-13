class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.receipt.subject
  #
  def receipt
    @order = Order.find(params[:order_id])
    mail to: @order.email, subject: "Warehouse Order Receipt"
  end
end
