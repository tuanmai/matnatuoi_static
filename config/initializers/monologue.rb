Monologue.config do |config|
  config.site_name = "Mặt nạ tươi"
  config.site_subtitle = "Xinh lắm cơ Í"
  config.site_url = "matnatuoi.com"

  config.meta_description = "This is my blog about..."
  config.meta_keyword = "music, fun"

  config.admin_force_ssl = false
  config.posts_per_page = 10
  config.preview_size = 200

  config.disqus_shortname = "matnatuoi"

  # LOCALE
  config.twitter_locale = "en" # "fr"
  config.facebook_like_locale = "en_US" # "fr_CA"
  config.google_plusone_locale = "en"

  config.layout               = "layouts/monologue/application"

  # ANALYTICS
  # config.gauge_analytics_site_id = "YOUR COGE FROM GAUG.ES"
  # config.google_analytics_id = "YOUR GA CODE"

  config.sidebar = ["latest_posts", "latest_tweets", "categories", "tag_cloud"]


  #SOCIAL
  config.facebook_url = "https://www.facebook.com/matnatuoi.xlci"
  config.facebook_logo = 'logo.png'
  config.show_rss_icon = true

end

# require 'monologue/controllers/monologue/admin/posts_controller'

Monologue::ApplicationController.class_eval do
  include ApplicationHelper

  before_action :set_default_meta_tags
  helper_method :facebook_meta_name, :facebook_meta_image, :facebook_meta_description

  def set_default_meta_tags
    set_meta_tags site: 'Mặt nạ tươi - Xinh Lắm cơ Í'
    set_meta_tags description: 'Mặt na tươi 100% tự nhiên nguyên chất - Xinh lắm cơ Í giúp chăm sóc da mặt.'
    set_meta_tags keywords: ['mặt nạ tươi', 'xinh lắm cơ í', 'chăm sóc da', 'làm trắng da', 'nguyên chất', 'làm đẹp', 'mặt nạ', 'mĩ phẩm']
    self.facebook_meta_name = 'Mặt nạ tươi - Xinh lắm cơ Í'
    self.facebook_meta_image = ActionController::Base.helpers.image_url('matnatuoi-logo')
    self.facebook_meta_description = 'Mặt na tươi 100% tự nhiên nguyên chất - Xinh lắm cơ Í giúp chăm sóc da mặt.'
  end
end


Monologue::Admin::PostsController.class_eval do
  def post_params
    params.require(:post).permit(:cover_image_url, :cover_image_file, :published, :tag_list,:title,:content,:url,:published_at)
  end
end
