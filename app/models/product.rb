class Product < ActiveRecord::Base
  belongs_to :week

  mount_uploader :image, PhotoUploader

  def image_data=(data)
    self.image = CarrierStringIO.new(Base64.decode64(data))
  end
end
