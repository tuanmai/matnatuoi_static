class FacebookMessageSyncService
  attr_accessor :messages_data

  def initialize(messages_data)
    self.messages_data = messages_data
  end

  def perform
    messages = MessengerPlatform::Parser.execute(messages_data)
    postback_messages = messages.select { |msg| msg[:type] == 'payload' }
    messages = messages.select { |msg| msg[:type] == 'message' }

    messages.each do |msg|
      fb_user = FacebookUser.where(facebook_id: msg[:sender_id]).first_or_create
      fb_user.facebook_messages.create(message: msg[:text])
      bot = FacebookBot.new(msg[:sender_id])
      bot.respond_to_message(msg[:text])
    end

    postback_messages.each do |msg|
      fb_user = FacebookUser.where(facebook_id: msg[:sender_id]).first_or_create
      bot = FacebookBot.new(msg[:sender_id])
      bot.respond_to_postback(msg[:text])
    end
  end
end
