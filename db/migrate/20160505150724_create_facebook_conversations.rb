class CreateFacebookConversations < ActiveRecord::Migration
  def change
    create_table :facebook_messages do |t|
      t.belongs_to :facebook_user
      t.string :timestamp
      t.string :facebook_mid
      t.text :message

      t.timestamps null: false
    end
  end
end
