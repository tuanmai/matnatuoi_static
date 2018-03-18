class Api::CustomersController < Api::BaseController
  def show
    render json: {
      name: customer.name,
      facebook_id: customer.facebook_id,
      weeks: weeks
    }
  end

  def customer
    @customer ||= Customer.find_by!(facebook_id: params[:id])
  end

  def weeks
    customer.weeks.map { |week| week.order_label }
  end
end
