module Sync
  class FacebookCustomer
    def call
      get_customer_data_from_notes
    end

    private

    def get_customer_data_from_notes
      Customer.update_from_google_drive
      FbPageApi.admin_notes.collection.map do |note|
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
    end

    def find_or_create_customer(facebook_user)
      Customer.where(facebook_id: facebook_user['id']).first_or_create do |customer|
       customer.name = facebook_user['name']
      end
    end

    def extract_customer_attributes(fb_note)
      skin_type, allergy, prefer, combo, phone_number, address, *customer_notes = *fb_note.split(';')
      note = customer_notes.join(';')
      if [skin_type, allergy, prefer, combo, phone_number, address].compact.size == 6
        {
          skin_type: skin_type,
          allergy: allergy,
          prefer: prefer,
          combo: combo,
          phone_number: phone_number,
          address: address,
          note: note,
        }
      end
    end
  end
end
