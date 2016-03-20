class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :note
      t.string :facebook_url
      t.string :price
      t.string :ship_time
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
  end
end
