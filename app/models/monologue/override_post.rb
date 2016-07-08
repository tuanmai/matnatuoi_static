module Monologue
  module OverridePost
    extend ActiveSupport::Concern

    included do
      mount_uploader :cover_image_file, PhotoUploader
    end
  end
end

::Monologue::Post.include Monologue::OverridePost
