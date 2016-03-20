class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :customers_orders, id: false do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :order, index: true
    end
  end
end
