class HomeController < ApplicationController
  def index
    set_meta_tags site: 'Mặt nạ tươi - Xinh Lắm cơ Í', title: 'Trang Chủ'
    @current_week = Week.last
    @previous_weeks = Week.with_products.order(created_at: :desc).last(3)
  end

  def help
  end
end
