require 'open-uri'
class FacebookUser < ActiveRecord::Base
  belongs_to :customer
  has_many :facebook_messages, dependent: :destroy
  before_save :fetch_user_name
  serialize :raw_data

  def customer_data
    {
      name: self.name,
      facebook_id: self.facebook_id,
      address: self.address,
      combo: self.order_type,
      photo_url: self.photo_url,
    }
  end

  def reset_status
    self.update_attribute(:wait_for_address, false)
  end

  private

  def fetch_user_name
    url = "https://graph.facebook.com/v2.6/#{self.facebook_id}?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=#{ENV['page_access_token']}"
    self.raw_data = HTTParty.get(url).parsed_response
    self.name = "#{raw_data['last_name']} #{raw_data['first_name']}"
    self.photo_url = raw_data['profile_pic']
  end
end
