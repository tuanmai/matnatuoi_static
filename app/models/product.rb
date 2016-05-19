class Product < ActiveRecord::Base
  belongs_to :week

  mount_uploader :image, PhotoUploader
end
