class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :destroy]
  before_action :authenticate_admin!, except: [:new, :create, :create_checkout_session, :pay, :success]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @ware = Ware.find(session[:processed_ware])
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.ware_id = session[:processed_ware]
    @order.checkout_session = create_checkout_session(@order)

    if @order.save
      session[:order_id] = @order.id
    else
      redirect_to new_order_url 
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def success
    @order = get_order_from_session
    @checkout_session = Stripe::Checkout::Session.retrieve(@order.checkout_session)
    ware = @order.ware
    @order.update!(paid: true)
    ware.update!(status: :sold)
    #TODO email customer receipt
    #TODO email self invoice copy
    reset_session_order_id
    session[:processed_ware] = nil
  end  

  def cancel
    @order = get_order_from_session
    @ware = @order.ware
    @order.delete
    @order = Order.new
    reset_session_order_id
    redirect_to new_order_url
  end

  private
    
    def reset_session_order_id
      session[:order_id] = nil
    end

    def get_order_from_session
      Order.find(session[:order_id])
    end

    def create_checkout_session(order) 
      checkout_session = Stripe::Checkout::Session.create({
        customer_email: order.email,
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'usd',
            product_data: {
              name: order.ware.name,
              description: order.ware.description,
              # images: [url_for(order.ware.image)],
            },
            unit_amount: order.ware.price_cents,
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: "http://localhost:3000/success",
        cancel_url: 'http://localhost:3000/cancel',
      })

      return checkout_session.id
      
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:first_name, :last_name, :street_address, :apt_num, :city, :state, :zip_code, :email)
    end
end
