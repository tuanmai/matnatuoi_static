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
end


Monologue::Admin::PostsController.class_eval do
  def post_params
    params.require(:post).permit(:cover_image_url, :cover_image_file, :published, :tag_list,:title,:content,:url,:published_at)
  end
end
