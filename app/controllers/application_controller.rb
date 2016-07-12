class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  attr_accessor :facebook_meta_name, :facebook_meta_image, :facebook_meta_description

  protect_from_forgery with: :exception
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

  def current_page
    params[:page] || 1
  end
end
