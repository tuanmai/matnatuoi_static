class AddOrderLabelToWeek < ActiveRecord::Migration
  def change
    add_column :weeks, :order_label, :string
  end
end
