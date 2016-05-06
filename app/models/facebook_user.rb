class FacebookUser < ActiveRecord::Base
  has_many :facebook_messages
end
