class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :destroy]
  before_action :authenticate_admin!, except: [:new, :create, :create_checkout_session, :success, :cancel ]

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
    ware = Ware.find(params[:ware_id])
    if ware.process
      store_ware_in_session(ware)
      broadcast_wares_to_warehouse
      @order = Order.new(ware: ware)
    else
      redirect_to root_url, notice: "Item no longer available"
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.checkout_session = create_checkout_session(@order)

    redirect_to new_order_url unless @order.save
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
    @order = Order.find_by(checkout_session: params[:session_id])
    if @order.payment_verified?
      @order.complete
    #TODO email customer receipt
    #TODO email self invoice copy
    else
      redirect_to :cancel, params: { checkout_session: @order.checkout_session }
    end
  end  
  
  def cancel
    @order = Order.find_by(checkout_session: params[:session_id])
    ware_id = @order.ware_id
    @order.cancel
    redirect_to new_order_url(ware_id: ware_id)
  end

  private

    def store_ware_in_session(ware)
      session[:ware_id] = ware.id
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
        success_url: "#{ success_url }?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{ cancel_url }?session_id={CHECKOUT_SESSION_ID}",
      })

      return checkout_session.id
      
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:ware_id, :first_name, :last_name, :street_address, :apt_num, :city, :state, :zip_code, :email)
    end
end
