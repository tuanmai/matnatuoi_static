class Admin::WeeksController < Admin::BaseController
  before_action :set_week, only: [:show, :edit, :update, :destroy]

  def index
    @weeks = Week.all.includes(:customers)
  end

  def show
  end

  def new
    Week.where(status: Week.statuses[:opening]).update_all(status: Week.statuses[:closed])
    @week = Week.create(status: Week.statuses[:pending])
    redirect_to edit_admin_week_path(@week)
  end

  def edit
    @customers_data = @week.customers.order(position: :asc).map(&:attributes_for_customer_data).join("\n").html_safe
  end

  def ship_info
    @week = Week.find params[:week_id]
  end

  def add_customer
    @week = Week.find params[:week_id]
    customer = Customer.find params[:customer_id]
    customer.add_order_week(@week)
    redirect_to edit_admin_week_path(@week)
  end

  def remove_customer
    @week = Week.find params[:week_id]
    customer = Customer.find params[:customer_id]
    customer.remove_order_week(@week)
    redirect_to edit_admin_week_path(@week)
  end

  def get_facebook_orders
    @week = Week.find params[:week_id]
    SyncFacebookOrderWorker.perform_async(@week.id)
    redirect_to edit_admin_week_path(@week), notice: 'Đang sync, vui lòng đợi trong giây lát.'
  end

  # PATCH/PUT /weeks/1
  # PATCH/PUT /weeks/1.json
  def update
    if params[:search_multi].present?
      params[:search_multi].split("\r\n").each do |name|
        customer = Customer.where("name ILIKE ?", name).first
        customer.add_order_week(@week) if customer
      end
    end
    @week.attributes = week_params
    @week.save
    render :edit
  end

  # DELETE /weeks/1
  # DELETE /weeks/1.json
  def destroy
    @week.destroy
    respond_to do |format|
      format.html { redirect_to admin_weeks_url, notice: 'Week was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_week
      @week = Week.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def week_params
      params.require(:week).permit!
    end
end
