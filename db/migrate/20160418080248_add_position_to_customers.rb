class AddPositionToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :position, :integer
  end
end
