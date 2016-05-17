class Admin::ConfirmOrdersController < Admin::BaseController
  before_action :get_order, only: [:edit, :update, :destroy]

  def index
    @orders = Order.active.includes(:weeks, :customer).select { |order| order.weeks.count >= order.num_of_weeks }
  end

  def update
    weeks = params[:num_of_weeks].to_i
    if weeks > 0
      @order.num_of_weeks += weeks
      @order.save
    end
    redirect_to action: :index
  end

  def destroy
    @order.update_attributes(active: false)
    redirect_to action: :index
  end

  private

  def get_order
    @order = Order.find params[:id]
  end
end
