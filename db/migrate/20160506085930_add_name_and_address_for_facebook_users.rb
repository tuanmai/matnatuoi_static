class AddNameAndAddressForFacebookUsers < ActiveRecord::Migration
  def change
    change_table :facebook_users do |t|
      t.belongs_to :customer, index: true
      t.string :address
      t.string :order_type
      t.string :order_id
      t.boolean :wait_for_address, default: false
      t.boolean :ordered, default: false
    end
  end
end
