class AddRawDataToFacebookUsers < ActiveRecord::Migration
  def change
    add_column :facebook_users, :raw_data, :text
    add_column :facebook_users, :photo_url, :string
    rename_column :facebook_users, :order_id, :week_id
    add_column :customers, :photo_url, :string
    add_column :customers, :facebook_id, :string
  end
end
