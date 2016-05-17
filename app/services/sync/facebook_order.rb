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
      find_week_label['users']['data'].map do |user|
        customer = find_or_create_customer(user)
        num_of_weeks = order_month?(user) ? 4 : 1
        customer.add_order_week(week.reload, num_of_weeks)
        customer
      end
    end

    private
    def ordered_month_users
      @ordered_month_users ||= begin
        month_label = find_month_label
        return [] unless month_label
        month_label['users']['data'].map { |user| user['id'] }.compact
      end
    end

    def order_month?(facebook_user)
      ordered_month_users.include? (facebook_user['id'])
    end

    def find_or_create_customer(facebook_user)
      Customer.where(facebook_id: facebook_user['id']).first_or_create do |customer|
       customer.name = facebook_user['name']
      end
    end

    def find_week_label
      @find_week_label ||= labels.lazy.select { |label| label['name'] == self.week.order_label && label['users'].present? }.first
    end

    def find_month_label
      @find_month_label ||= labels.lazy.select { |label| label['name'] == ENV['order_month_label'] && label['users'].present? }.first
    end

    def labels
      @labels ||= FbPageApi.labels.collection
    end
  end
end
