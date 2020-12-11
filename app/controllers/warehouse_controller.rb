class WarehouseController < ApplicationController
  def index
    if session[:processed_ware]
      ware = Ware.find(session[:processed_ware])
      if ware.processing? 
        ware.update!(status: :available)
        broadcast_wares_to_warehouse
      end
    end
    session.delete(:processed_ware)
    @wares = Ware.where(status: :available).order(:price_cents)
  end
end
