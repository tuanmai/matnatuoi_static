namespace :customer do
  desc "Sync from facebook"
  task :sync_facebook => :environment do |t|
    Customer.update_from_google_drive
    conversations = FbPageApi.conversations.collection
    user_ids = conversations.map do |conversation|
      conversation_id = conversation['id']
      messages = FbPageApi.messages(conversation_id).collection
      user_message = messages.lazy.select { |message| message['from']['id'] != ENV['facebook_page_id'] }.take(1).first
      user_id = user_message['from']['id']
      puts user_id
      user_id
    end
    user_ids.each do |user_id|
      begin
        user = FbPageApi.users.get(user_id)
        customer = Customer.where(name: user['name']).first
        customer.update_attributes(facebook_id: user['id']) if customer
      rescue
      end
    end
  end
end
