class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all.includes(:customers)
  end

  def show
  end

  def new
    @order = Order.create
    redirect_to edit_order_path(@order)
  end

  def edit
  end

  def add_customer
    @order = Order.find params[:order_id]
    customer = Customer.find params[:customer_id]
    unless @order.customers.include?(customer)
      @order.customers << customer
      @order.save
    end
    redirect_to edit_admin_order_path(@order)
  end

  def remove_customer
    @order = Order.find params[:order_id]
    customer = Customer.find params[:customer_id]
    @order.customers.delete(customer)
    @order.save
    redirect_to edit_admin_order_path(@order)
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    params[:search_multi].split("\r\n").each do |name|
      customer = Customer.where("name ILIKE ?", name).first
      @order.customers << customer if customer
    end
    @order.save
    render :edit
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit!
    end
end
