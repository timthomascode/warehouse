class ApplicationController < ActionController::Base
  
  def broadcast_wares_to_warehouse
    @wares = Ware.where(status: :available).order(:created_at)
    ActionCable.server.broadcast('warehouse', { html: render_to_string('warehouse/index', layout: false) })
  end
end
