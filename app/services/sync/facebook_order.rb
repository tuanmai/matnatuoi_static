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
      FacebookPageToken.order(id: :asc).all.map do |page|
        if find_week_label(page.page_id)
          p find_week_label(page.page_id)
          p @find_week_label
          fb_label_users =FbPageApi.label_users(find_week_label(page.page_id)['id'], { parent_id: page.page_id, page_access_token: page.access_token }) 
          fb_label_users.collection.map do |user|
            customer = find_or_create_customer(user)
            num_of_weeks = 1
            customer.add_order_week(week.reload, num_of_weeks)
            customer
          end
        else
          []
        end
      end.flatten
    end

    private
    def find_or_create_customer(facebook_user)
      Customer.where(facebook_id: facebook_user['id']).first_or_create do |customer|
       customer.name = facebook_user['name']
       customer.position = (Customer.unscoped.maximum(:position) || 0) + 1
      end
    end

    def find_week_label(page_id)
      @find_week_label ||= {}
      @find_week_label[page_id] ||= labels[page_id].lazy.select { |label| label['name'] == self.week.order_label }.first
    end

    def labels
      @labels ||= FacebookPageToken.all.inject({}) do |rs, page|
        rs[page.page_id] = FbPageApi.labels(parent_id: page.page_id, page_access_token: page.access_token).collection
        rs
      end
    end
  end
end
