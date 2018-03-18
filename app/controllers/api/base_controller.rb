class Api::BaseController < ApplicationController
  before_action :authenticate!

  def authenticate!
    if params[:token] != ENV['authenticate_token']
      raise AuthorizationException
    end
  end
end
