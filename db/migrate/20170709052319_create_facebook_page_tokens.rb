class CreateFacebookPageTokens < ActiveRecord::Migration
  def change
    create_table :facebook_page_tokens do |t|
      t.string :page_name
      t.string :page_id
      t.string :access_token

      t.timestamps null: false
    end
  end
end
