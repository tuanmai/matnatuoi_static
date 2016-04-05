class CreateGoogleConfig < ActiveRecord::Migration
  def change
    create_table :google_configs do |t|
      t.string :client_id
      t.string :client_secret
      t.string :refresh_token
    end
  end
end
