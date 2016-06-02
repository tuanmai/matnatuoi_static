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

    def sync_customer_from_node(note)
      customer = find_or_create_customer(note['user'])
      new_attributes =  extract_customer_attributes(note['body'])
      if new_attributes
        customer.attributes = new_attributes
        customer.save
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
      skin_type, allergy, prefer, phone_number, address, price, *customer_notes = *fb_note.split(';')
      note = customer_notes.join(';')
      if address.present?
        {
          skin_type: skin_type,
          allergy: allergy,
          prefer: prefer,
          phone_number: phone_number,
          address: address,
          price: price,
          note: note,
        }
      end
    end
  end
end
