class Customer < ActiveRecord::Base
  has_and_belongs_to_many :orders

  def name_and_phone_number
    "#{name} - #{phone_number}"
  end
end
