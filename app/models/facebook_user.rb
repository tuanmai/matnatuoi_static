require 'open-uri'
class FacebookUser < ActiveRecord::Base
  has_many :facebook_messages
  belongs_to :customer

  before_create :fetch_user_name

  def facebook_url
    "https://www.facebook.com/profile.php?id=#{self.facebook_id}"
  end

  def customer_data
    {
      name: self.name,
      facebook_url: self.facebook_url,
      address: self.address,
      combo: self.order_type,
    }
  end

  private

  def fetch_user_name
    page = Nokogiri::HTML(open("https://www.facebook.com/profile.php?id=#{self.facebook_id}"))
    name = page.css("#fb-timeline-cover-name").try(:text)
    self.name = name
  end
end
