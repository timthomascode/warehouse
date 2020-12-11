class WarehouseController < ApplicationController
  def index
    if session[:ware_id]
      ware = Ware.find(session[:ware_id])
      if ware.processing? 
        ware.update!(status: :available)
        broadcast_wares_to_warehouse
      end
    end
    session.delete(:ware_id)
    @wares = Ware.where(status: :available).order(:created_at)
  end
end
