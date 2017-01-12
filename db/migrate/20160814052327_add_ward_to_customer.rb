class AddWardToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :ward, :string
  end
end
