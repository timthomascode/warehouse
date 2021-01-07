class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :destroy]
  before_action :authenticate_admin!, only: [:index, :show, :edit]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  def start
    ware = Ware.find(params[:ware_id])
    if ware.process
      store_ware_in_session(ware)
      broadcast_wares_to_warehouse
      @order = Order.new(ware: ware)
      @order.save(validate: false)
      OrderTimeoutJob.set(wait: 15.minutes).perform_later(@order.id)
    else
      redirect_to root_url, notice: "Ware no longer available"
    end
  end

  def continue
    @order = Order.find(filtered_params[:order_id])
    @order.first_name = filtered_params[:first_name]
    @order.last_name = filtered_params[:last_name]
    @order.street_address = filtered_params[:street_address]
    @order.apt_num = filtered_params[:apt_num]
    @order.city = filtered_params[:city]
    @order.state = filtered_params[:state]
    @order.zip_code = filtered_params[:zip_code]
    @order.email = filtered_params[:email]

    if @order.valid?
      @order.stripe_session_id = StripeAdapter.new_checkout_session_for(@order)["id"]
      @order.save
    else
      redirect_to start_order_url(ware_id: @order.ware.id), notice: "Missing order fields"
    end
  end

  # GET /orders/1/edit
  def edit
  end
  
  def success
    @order = Order.find_by(stripe_session_id: params[:session_id])
    if @order.complete
      OrderMailer.with(order_id: @order.id).receipt.deliver_later
    else
      redirect_to cancel_url(stripe_session_id: @order.stripe_session_id)
    end
  end  

  def cancel
    @order = Order.find_by(stripe_session_id: params[:session_id])
    ware_id = @order.ware_id
    @order.cancel
    redirect_to start_order_url(ware_id: ware_id)
  end

  private

    def store_ware_in_session(ware)
      session[:ware_id] = ware.id
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:ware_id, :first_name, :last_name, :street_address, :apt_num, :city, :state, :zip_code, :email)
    end
    def filtered_params
      params.require(:order).permit(:order_id, :first_name, :last_name, :street_address, :apt_num, :city, :state, :zip_code, :email)
    end
end
