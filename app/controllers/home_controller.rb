class HomeController < ApplicationController
  def index
    set_meta_tags site: 'Mặt nạ tươi - Xinh Lắm cơ Í', title: 'Trang Chủ'
    @current_week = Week.last
    @previous_weeks = Week.where.not(id: @current_week.id).last(3)
  end
end
