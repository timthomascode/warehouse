class WarehouseController < ApplicationController
  def index
    if session[:processed_ware]
      ware = Ware.find(session[:processed_ware])
      if ware.processing? 
        ware.update!(status: :available)
        broadcast_wares_to_warehouse
      end
      session[:processed_ware] = nil
    end
    @wares = Ware.where(status: :available).order(:price_cents)
  end
end
