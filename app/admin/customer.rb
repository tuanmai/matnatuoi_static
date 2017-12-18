ActiveAdmin.register Customer do
  config.sort_order = 'position_asc'
  config.per_page = 1000

  permit_params :position, :name, :skin_type, :phone_number, :address, :district, :price,
                :ship_time, :note, :facebook_id, :facebook_name, :ward, :allergy

  filter :weeks
  filter :name
  filter :skin_type
  filter :allergy
  filter :phone_number
  filter :address
  filter :district

  action_item :download_all do
    link_to 'Download phone', download_all_activeadmin_customers_path, method: :post
  end

  collection_action :download_all, method: :post do
    csv_data = CSV.generate do |csv|
      csv << %w(Name, Phone, Address)
      Customer.all.joins(:weeks).includes(:weeks).each do |customer|
        data = [
          customer.name,
          "#{customer.phone_number} ",
          customer.address,
        ]
        csv << data
      end
    end
    send_data csv_data, type: 'text/csv; header=present', disposition: "attachment; filename=phone_numbers.csv"
  end

  index do
    column :position, sortable: false do |position|
      best_in_place position, :position, as: :textarea, url: [:activeadmin, position]
    end
    column :name, sortable: false do |name|
      best_in_place name, :name, as: :textarea, url: [:activeadmin, name]
    end
    column :skin_type, sortable: false do |skin_type|
      best_in_place skin_type, :skin_type, as: :textarea, url: [:activeadmin, skin_type]
    end
    column :allergy do |allergy|
      best_in_place allergy, :allergy, as: :textarea, url: [:activeadmin, allergy]
    end
    column :phone_number, sortable: false do |phone_number|
      best_in_place phone_number, :phone_number, as: :textarea, url: [:activeadmin, phone_number]
    end
    column :address, sortable: false do |address|
      best_in_place address, :address, as: :textarea, url: [:activeadmin, address]
    end
    column :ward, sortable: :ward do |ward|
      best_in_place ward, :ward, as: :textarea, url: [:activeadmin, ward]
    end
    column :district, sortable: :district do |district|
      best_in_place district, :district, as: :textarea, url: [:activeadmin, district]
    end
    column :price, sortable: true do |price|
      best_in_place price, :price, as: :textarea, url: [:activeadmin, price]
    end
    column :ship_time, sortable: false do |ship_time|
      best_in_place ship_time, :ship_time, as: :textarea, url: [:activeadmin, ship_time]
    end
    column :note, sortable: false do |note|
      best_in_place note, :note, as: :textarea, url: [:activeadmin, note]
    end
    column :conversation_link, sortable: false do |customer|
      "https://business.facebook.com/matnatuoi.xlci/messages/?threadid=#{customer.facebook_id}"
    end
  end

  csv force_quotes: true do
    column :name
    column :phone_number
    column :address
    column :ward
    column :district
    column :price
    column :ship_time
    column :note
    column :allergy
    column :conversation_link do |customer|
      "https://business.facebook.com/matnatuoi.xlci/messages/?threadid=#{customer.facebook_id}"
    end
  end
end
