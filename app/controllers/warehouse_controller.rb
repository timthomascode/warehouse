class WarehouseController < ApplicationController
  def index
    cleanup_session_storage
    @wares = Ware.where(status: :available).order(:created_at)
  end

  private

  def cleanup_session_storage
    if session[:ware_id]
      ware = Ware.find(session[:ware_id])
      broadcast_wares_to_warehouse if ware.unprocess
      session.delete(:ware_id)
    end
  end
end
