class FacebookWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    if params['hub.verify_token'] == ENV['facebook_webhook_verify_token']
      render text: params['hub.challenge']
    else
      render text: 'wrong token'
    end
  end

  def create
    head :ok
  end
end
