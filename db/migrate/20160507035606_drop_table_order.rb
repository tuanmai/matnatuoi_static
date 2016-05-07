class DropTableOrder < ActiveRecord::Migration
  def self.up
    remove_column :products, :order_id
    drop_table :customers_orders
    drop_table :orders
  end

  def self.down
    create_table :orders do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :customers_orders, id: false do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :order, index: true
    end

    add_column :products, :order_id, :string
  end
end
