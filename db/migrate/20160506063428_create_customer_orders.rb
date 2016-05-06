class CreateCustomerOrders < ActiveRecord::Migration
  def change
    add_column :customers_orders, :order_type, :string
  end
end
