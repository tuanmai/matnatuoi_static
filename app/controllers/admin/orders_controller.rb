class Admin::OrdersController < Admin::BaseController
  before_action :get_order, only: [:edit, :update]

  def index
    @orders = Order.all.includes(:weeks, :customer)
  end

  def edit
  end

  def update
    if @order.update_attributes(order_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  private

  def get_order
    @order = Order.find params[:id]
  end

  def order_params
    params.require(:order).permit!
  end
end
