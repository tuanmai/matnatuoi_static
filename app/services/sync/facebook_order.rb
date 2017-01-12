module Sync
  class FacebookOrder
    attr_accessor :week

    def initialize(week)
      self.week = week
    end

    def call
      get_order_users
    end

    def get_order_users
      return [] unless find_week_label
      FbPageApi.label_users(find_week_label['id']).collection.map do |user|
        customer = find_or_create_customer(user)
        num_of_weeks = 1
        customer.add_order_week(week.reload, num_of_weeks)
        customer
      end
    end

    private
    def find_or_create_customer(facebook_user)
      Customer.where(facebook_id: facebook_user['id']).first_or_create do |customer|
       customer.name = facebook_user['name']
       customer.position = (Customer.unscoped.maximum(:position) || 0) + 1
      end
    end

    def find_week_label
      @find_week_label ||= labels.lazy.select { |label| label['name'] == self.week.order_label }.first
    end

    def labels
      @labels ||= FbPageApi.labels.collection
    end
  end
end
