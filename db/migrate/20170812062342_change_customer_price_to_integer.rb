class ChangeCustomerPriceToInteger < ActiveRecord::Migration
  def change
    add_column :customers, :total_price, :integer, default: 0
  end
end
