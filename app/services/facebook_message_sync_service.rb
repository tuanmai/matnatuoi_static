class FacebookMessageSyncService
  attr_accessor :messages_data

  def initialize(messages_data)
    self.messages_data = messages_data
  end

  def perform
    messages_data.each do |message_data|
      if message_data[:message].present?
        fb_user = FacebookUser.where(facebook_id: message_data[:sender][:id]).first_or_create
        fb_user.facebook_messages.where(facebook_mid: message_data[:message][:mid]).first_or_create do |message|
          message.message = message_data[:message][:text]
          message.timestamp = message_data[:timestamp]
        end
      end
    end
  end
end
