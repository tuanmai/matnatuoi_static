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
        customer.attributes = extract_customer_attributes(note['body'])
        customer.save
        customer
      end
    end

    def find_or_create_customer(facebook_user)
      Customer.where(facebook_id: facebook_user['id']).first_or_create do |customer|
       customer.name = facebook_user['name']
      end
    end

    def extract_customer_attributes(fb_note)
      address, phone_number, skin_type, allergy, prefer, *customer_notes = *fb_note.split(';')
      note = customer_notes.join(';')
      if [address, phone_number, skin_type, allergy, prefer].compact.size == 5
        {
          address: address,
          phone_number: phone_number,
          skin_type: skin_type,
          allergy: allergy,
          prefer: prefer,
          note: note,
        }
      else
        { note: fb_note }
      end
    end
  end
end
