class WarehouseController < ApplicationController
  def index
    if session[:processed_ware]
      ware = Ware.find(session[:processed_ware])
      ware.update!(status: :available) unless ware.status == :sold
      session[:processed_ware] = nil
    end
    @wares = Ware.where(status: :available)
  end
end
