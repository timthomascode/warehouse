class WarehouseChannel < ApplicationCable::Channel
  def subscribed
    stream_from "warehouse"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
