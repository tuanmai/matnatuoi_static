class AddFacebookNameToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :facebook_name, :string
  end
end
