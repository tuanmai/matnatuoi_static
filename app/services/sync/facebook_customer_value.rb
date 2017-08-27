module Sync
  class FacebookCustomerValue
    def call
      Sync::FacebookCustomer.new.call
      get_customer_values
    end

    def get_customer_values
      FacebookPageToken.all.map do |page|
        week_labels = labels[page.page_id].select{ |label| label['name'].match(/^\d+$/) }
        week_labels.each do |label|
          fb_label_users = FbPageApi.label_users(label['id'], { parent_id: page.page_id, page_access_token: page.access_token })  
          fb_label_users.collection.map do |user|
            customer = find_or_create_customer(user)
            customer.total_price += 100
            customer.save
          end
        end
      end
    end

    private
    def find_or_create_customer(facebook_user)
      Customer.where(facebook_id: facebook_user['id']).first_or_create do |customer|
       customer.name = facebook_user['name']
       customer.position = (Customer.unscoped.maximum(:position) || 0) + 1
       customer.total_price = 0
      end
    end

    def labels
      @labels ||= FacebookPageToken.all.inject({}) do |rs, page|
        rs[page.page_id] = FbPageApi.labels(parent_id: page.page_id, page_access_token: page.access_token).collection
        rs
      end
    end
  end
end
