class AddStatusToWares < ActiveRecord::Migration[6.0]
  def up
    add_column :wares, :status, :string, default: :available
    wares = Ware.all
    wares.each do |ware|
      ware.status = "available"
      ware.save!
    end
  end
  def down
    remove_column :wares, :status
  end
end
