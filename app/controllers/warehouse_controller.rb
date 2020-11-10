class WarehouseController < ApplicationController
  def index
    @wares = Ware.all
  end
end
