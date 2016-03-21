class AddDistrictToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :district, :string
    add_column :customers, :place_url, :string
    add_column :customers, :skin_type, :string
    add_column :customers, :allergy, :string
    add_column :customers, :prefer, :string
    add_column :customers, :combo, :string
  end
end
