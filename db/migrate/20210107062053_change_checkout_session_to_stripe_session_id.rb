class ChangeCheckoutSessionToStripeSessionId < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :checkout_session, :stripe_session_id
  end
end
