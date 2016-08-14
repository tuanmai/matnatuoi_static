module Sync
  class FacebookCustomer
    def call
      sync_customers_from_notes
    end

    private
    def sync_customers_from_notes
      Customer.update_from_google_drive
      FbPageApi.admin_notes.collection.map do |note|
        sync_customer_from_node(note)
      end
    end

    def update_notes
      FbPageApi.admin_notes.collection.map do |note|
        customer = Customer.where(facebook_id: note['user']['id']).first
        new_attributes =  extract_customer_attributes(note['body'])
        if customer && new_attributes
          # p note['body']
          FbPageApi.admin_notes.delete(note['id'])
        end
      end

      Customer.all.each do |customer|
        begin
          if customer.facebook_id.present? && !customer.facebook_id.include?('E+')
            # p "#{customer.facebook_id} - #{customer.new_facebook_format_note}"
            FbPageApi.admin_notes.create(user_id: customer.facebook_id, body: customer.new_facebook_format_note)
          end
        rescue
        end
      end
    end

    def sync_customer_from_node(note)
      customer = find_or_create_customer(note['user'])
      new_attributes =  extract_customer_attributes(note['body'])
      if new_attributes
        new_note  = new_attributes.delete(:note)
        customer.attributes = new_attributes
        customer.save
        customer.add_note(new_note)
      else
        customer.add_note(note['body'])
      end
      customer
    end

    def find_or_create_customer(facebook_user)
      Customer.where(facebook_id: facebook_user['id']).first_or_create do |customer|
       customer.name = facebook_user['name']
       customer.position = (Customer.unscoped.maximum(:position) || 0) + 1
      end
    end

    def extract_customer_attributes(fb_note)
      skin_type, allergy, phone_number, address, ward, district, price, ship_time, *customer_notes = *fb_note.split(';')
      note = customer_notes.join(';')
      if address.present?
        {
          skin_type: skin_type,
          allergy: allergy,
          phone_number: phone_number,
          address: address,
          ward: ward,
          district: district,
          price: price,
          ship_time: ship_time,
          note: note,
        }
      end
    end
  end
end
