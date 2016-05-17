class FacebookMessageSyncService
  attr_accessor :messages_data

  def initialize(messages_data)
    self.messages_data = messages_data
  end

  def perform
    messages.each do |message|
      track_user_message(message)
      answer_message(message)
    end
  end

  private

  def messages
    @messages ||= MessengerPlatform::Parser.execute(messages_data)
  end

  def track_user_message(message)
    facebook_user = FacebookUser.where(facebook_id: message[:sender_id]).first_or_create
    facebook_user.facebook_messages.create(message: message[:text])
  end

  def answer_to_message(message)
    bot = FacebookBot.new(message[:sender_id])
    if message[:type] == 'payload'
      bot.respond_to_postback(message[:text])
    else
      bot.respond_to_message(message[:text])
    end
  end
end
