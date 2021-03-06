class FacebookBot
  attr_accessor :user_id, :active_week, :order
  def initialize(user_id)
    self.user_id = user_id
  end

  def respond_to_message(message)
    if message == 'xem menu'
      list_products
    elsif fb_user.reload.wait_for_address
      can_order fb_user.week_id do
        set_ship_address(message)
        order = finish_order
        confirm_order(order)
      end
    end
  end

  def respond_to_postback(payload)
    if payload.include?("order")
      process_order(payload)
    end
  end

  def list_products
    week = Week.where(status: Week.statuses[:opening]).last
    if week.blank?
      notify_no_active_week
      puts MessengerPlatform.text(self.user_id, "Đây là menu tuần trước, mời bạn tham khảo").inspect
      week = Week.last
    end
    products = week.products
    products_data = products.map { |product| payload_data(product) }
    puts MessengerPlatform.payload(:generic, self.user_id, products_data).inspect
  end

  private

  def fb_user
    @fb_user ||= FacebookUser.where(facebook_id: self.user_id).first
  end

  def customer
    @customer ||= fb_user.customer || Customer.create(facebook_user: fb_user)
  end

  # View menu
  def payload_data(product)
    data = {
      title: product.name,
      image_url: product.image_url,
      subtitle: product.description,
      buttons: [
        {
          type: "web_url",
          url: product.product_url,
          title: "Xem sản phẩm"
        },
        {
          type: "postback",
          title: "Mua tuần - 90K",
          payload: "order_#{product.week.id}",
        },
        {
          type: "postback",
          title: "Mua tháng - 340K",
          payload: "order_month_#{product.week.id}",
        },
      ]
    }
  end

  # Start order
  def process_order(payload)
    if payload.include?("order_month")
      order_type = 'month'
      week_id = payload.gsub("order_month_", "")
    else
      order_type = 'week'
      week_id = payload.gsub("order_", "")
    end

    can_order week_id do
      fb_user.ordered = true
      fb_user.order_type = order_type
      fb_user.week_id = week_id
      request_ship_address
      fb_user.save
    end
  end

  def request_ship_address
    fb_user.wait_for_address = true
    puts MessengerPlatform.text(self.user_id, "Làm ơn nhập địa chỉ ship và số điện thoại (1 dòng)").inspect
  end

  # Confirm order
  def set_ship_address(message)
    fb_user.wait_for_address = false
    fb_user.address = message
    fb_user.save
  end

  def finish_order
    customer.attributes = fb_user.customer_data
    customer.save
    week = Week.where(id: fb_user.week_id, status: Week.statuses[:opening]).first
    if week
      # return active_order
      num_of_weeks = fb_user.order_type == 'month' ? 4 : 1
      customer.add_order_week(week, num_of_weeks)
    else
      nil
    end
  end

  def notify_no_active_week
    puts MessengerPlatform.text(self.user_id, "Hiện tại chưa có menu tuần mới nên chưa đặt hàng được xin bạn thông cảm. Shop sẽ báo lại cho bạn khi có menu mới").inspect
  end

  def confirm_order(order)
    if fb_user.order_type == 'week'
      cost = 90000
      element = {
        "title" => "Combo mặt nạ 1 tuần",
        "subtitle" => "Gồm #{order.weeks.last.products.pluck(:name).join(', ')}",
        "quantity" => 1,
        "price" => 90000,
        "currency" => "VND",
        "image_url" => "#{order.weeks.last.products.first.image_url}"
      }
    else
      cost = 340000
      element = {
        "title" => "Combo mặt nạ 1 tháng",
        "subtitle" => "Gồm tuần này: #{order.weeks.last.products.pluck(:name).join(', ')}",
        "quantity" => 1,
        "price" => 340000,
        "currency" => "VND",
        "image_url" => "#{order.weeks.last.products.first.image_url}"
      }
    end
    recipient_data = {
      "recipient_name" => fb_user.name || fb_user.facebook_url,
      "currency" => "VND",
      "order_number" => "#{fb_user.facebook_id}_#{order.id}_#{order.weeks.last.id}_#{Time.now.to_i}",
      "payment_method" => "Thanh toán lúc ship",
      "timestamp" => Time.now.to_i,
      "elements" => [element],
      "address" => {
        "street_1" => fb_user.address,
        "city" => "Hồ Chí Minh",
        "postal_code" => "70000",
        "state" => "Việt Nam",
        "country" => "Việt Nam"
      },
      "summary" => {
        "subtotal" => cost/100,
        "total_cost" => cost/100
      }
    }

    puts MessengerPlatform.payload(:receipt, self.user_id, recipient_data).inspect
  end

  def check_active_week(week_id)
    self.active_week = Week.where(id: week_id, status: Week.statuses[:opening]).last
    if self.active_week.present?
      true
    else
      fb_user.reset_status
      notify_no_active_week
      false
    end
  end

  def check_ordered(week_id)
    if customer.active_order && customer.active_order.week_ids.include?(week_id.to_i)
      fb_user.reset_status
      puts MessengerPlatform.text(self.user_id, "Bạn đã order tuần này rồi, nếu bạn muốn sửa order vui lòng liên hệ shop để giải quyết.").inspect
      return true
    end
    false
  end

  def can_order(week_id)
    if check_active_week(week_id) && !check_ordered(week_id)
      yield if block_given?
      true
    else
      false
    end
  end
end
