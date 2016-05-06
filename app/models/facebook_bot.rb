class FacebookBot
  attr_accessor :user_id
  def initialize(user_id)
    self.user_id = user_id
  end

  def respond_to_message(message)
    if message == 'xem menu'
      list_products
    elsif fb_user.wait_for_address
      set_ship_address(message)
      order = finish_order
      confirm_order(order)
    end
  end

  def respond_to_postback(payload)
    if payload.include?("order")
      process_order(payload)
    end
  end

  def list_products
    order = Order.last
    products = order.products
    products_data = products.map { |product| payload_data(product) }
    MessengerPlatform.payload(:generic, self.user_id, products_data)
  end

  private

  def fb_user
    @fb_user ||= FacebookUser.where(facebook_id: self.user_id).first
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
          payload: "order_#{product.order.id}",
        },
        {
          type: "postback",
          title: "Mua tháng - 340K",
          payload: "order_month_#{product.order.id}",
        },
      ]
    }
  end

  # Start order
  def process_order(payload)
    if payload.include?("order_month")
      order_type = 'month'
      order_id = payload.gsub("order_month_", "")
    else
      order_type = 'week'
      order_id = payload.gsub("order_", "")
    end

    fb_user.ordered = true
    fb_user.order_type = order_type
    fb_user.order_id = order_id
    request_ship_address
    fb_user.save
  end

  def request_ship_address
    fb_user.wait_for_address = true
    MessengerPlatform.text(self.user_id, "Làm ơn nhập địa chỉ ship và số điện thoại (1 dòng)")
  end

  # Confirm order
  def set_ship_address(message)
    fb_user.wait_for_address = true
    fb_user.address = message
    fb_user.save
  end

  def finish_order
    customer = fb_user.customer || Customer.new(facebook_user: fb_user)
    customer.attributes = fb_user.customer_data
    order = Order.where(id: fb_user.order_id).first
    customer.orders << order
    customer.save
    order
  end

  def confirm_order(order)
    if fb_user.order_type == 'week'
      cost = 900
      element = {
        "title" => "Combo mặt nạ 1 tuần",
        "subtitle" => "Gồm #{order.products.pluck(:name).join(', ')}",
        "quantity" => 1,
        "price" => 900,
        "currency" => "VND",
        "image_url" => "#{order.products.first.image_url}"
      }
    else
      cost = 3400
      element = {
        "title" => "Combo mặt nạ 1 tháng",
        "subtitle" => "Gồm tuần này: #{order.products.pluck(:name).join(', ')}",
        "quantity" => 1,
        "price" => 3400,
        "currency" => "VND",
        "image_url" => "#{order.products.first.image_url}"
      }
    end
    recipient_data = {
      "recipient_name" => fb_user.name || fb_user.facebook_url,
      "currency" => "VND",
      "order_number" => "#{fb_user.facebook_id}_#{order.id}_#{Time.now.to_i}",
      "payment_method" => "Thanh toán lúc ship",
      "timestamp" => Time.now.to_i,
      "elements" => [element],
      "address" => {
        "street_1" => fb_user.address,
        "city" => "Hồ Chí Minh",
        "postal_code" => "70000",
        "state" => "HCM",
        "country" => "Việt Nam"
      },
      "summary" => {
        "subtotal" => cost,
        "total_cost" => cost
      }
    }

    puts MessengerPlatform.payload(:receipt, self.user_id, recipient_data).inspect
  end
end
