class ChangeDefaults < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:orders, :paid, from: true, to: false)
    change_column_default(:wares, :status, :available)
  end
end
