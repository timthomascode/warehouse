class StripeAdapter
  include ActionController::UrlFor

  def self.verify_payment_for(order)
    begin
      Stripe::Checkout::Session.retrieve(order.stripe_session_id).payment_status == "paid"
    rescue
      false
    end
  end

  def self.new_checkout_session_for(order, url1, url2) 
    begin
      Stripe::Checkout::Session.create({
        customer_email: order.email,
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'usd',
            product_data: {
              name: order.ware.name,
              description: order.ware.description,
            },
            unit_amount: order.ware.price_cents,
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: "#{ url1 }?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{ url2 }?session_id={CHECKOUT_SESSION_ID}",
      })
    rescue Exception => e
      nil
    end
  end

  def self.cancel_payment_intent_for(order)
    begin
      checkout_session = Stripe::Checkout::Session.retrieve(order.stripe_session_id)
      Stripe::PaymentIntent.cancel(checkout_session["payment_intent"])
    rescue
      nil
    end
  end
end
