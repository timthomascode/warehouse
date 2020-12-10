class WarehouseController < ApplicationController
  def index
    if session[:processed_ware]
      ware = Ware.find(session[:processed_ware])
      if ware.processing? 
        ware.update!(status: :available)
      end
      @wares = Ware.where(status: :available).order(:price_cents)
      ActionCable.server.broadcast('warehouse', { html: render_to_string('warehouse/index', layout: false )})
      session[:processed_ware] = nil
    end
    @wares = Ware.where(status: :available).order(:price_cents)
  end
end
