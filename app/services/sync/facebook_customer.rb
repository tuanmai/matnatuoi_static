module Sync
  class FacebookCustomer
    def call
      sync_customers_from_notes
    end

    private
    def sync_customers_from_notes
      admin_notes_by_customer.each do |customer_id, notes|
        sync_customer_from_nodes(notes)
      end
    end

    def admin_notes_by_customer
      notes_by_customer = {}
      FbPageApi.admin_notes.collection.each do |note|
        notes_by_customer[note['user']['id']] ||= []
        notes_by_customer[note['user']['id']] << note
      end
      notes_by_customer
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

    def sync_customer_from_nodes(notes)
      customer = find_or_create_customer(notes.first['user'])
      final_note = ''
      notes.each do |note|
        new_attributes =  extract_customer_attributes(note['body'])
        if new_attributes
          new_note  = new_attributes.delete(:note)
          if customer.note_body.blank? || customer.note_body != note['body']
            customer.attributes = new_attributes
            customer.note_id = note['id']
            customer.note_body = note['body']
            customer.note_data = note
            customer.save
            # customer.add_note(new_note)
          end
          final_note = final_note == '' ? new_note : final_note + "; #{new_note}"
        else
          final_note = final_note == '' ? note['body'] : final_note + "; #{note['body']}"
        end
      end
      customer.note = final_note
      customer.save
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
