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
      return [] unless order_week_label
      order_week_label['users']['data'].map do |user|
        customer = Customer.where(facebook_id: user['id']).first_or_create do |c|
          c.facebook_id = user['id']
          c.name = user['name']
        end
        num_of_weeks = month_users.include?(user['id']) ? 4 : 1
        customer.add_order_week(week.reload, num_of_weeks)
        customer
      end
    end

    private
    def order_week_label
      labels.select { |label| label['name'] == self.week.order_label && label['users'].present? }.first
    end

    def month_users
      @month_users ||= begin
        month_label = labels.select { |label| label['name'] == ENV['order_month_label'] && label['users'].present? }.first
        if month_label
          month_label['users']['data'].map { |user| user['id'] }.compact
        else
          []
        end
      end
    end

    def labels
      @labels ||= FbPageApi.labels.collection
    end
  end
end
