ActiveAdmin.register Customer do
  config.sort_order = 'position_asc'
  config.paginate = false

  permit_params :position, :name, :skin_type, :phone_number, :address, :district, :price,
                :ship_time, :note, :facebook_id, :facebook_name, :ward, :allergy

  filter :weeks
  filter :name
  filter :skin_type
  filter :allergy
  filter :phone_number
  filter :address
  filter :district

  action_item :download_all_phonenumber do
    link_to 'Download phone', download_all_phonenumber_activeadmin_customers_path, method: :post
  end

  collection_action :download_all_phonenumber, method: :post do
    csv = CSV.generate do |csv|
			csv << ["Name", "Phone"]
      Customer.all.each do |customer|
				csv << [customer.name, customer.phone_number.to_s]
			end
    end
    send_data csv, type: 'text/csv; header=present', disposition: "attachment; filename=phone_numbers.csv"
  end

  collection_action :sync_back, method: :post do
    Sync::FacebookCustomer.new.sync_back
    redirect_to :back, notice: 'Synced Back to Facebook'
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
    column :price, sortable: false do |price|
      best_in_place price, :price, as: :textarea, url: [:activeadmin, price]
    end
    column :ship_time, sortable: false do |ship_time|
      best_in_place ship_time, :ship_time, as: :textarea, url: [:activeadmin, ship_time]
    end
    column :note, sortable: false do |note|
      best_in_place note, :note, as: :textarea, url: [:activeadmin, note]
    end


    actions defaults: true do |customer|
      link_to 'Sync Back', sync_back_activeadmin_customer_path(customer), method: :post
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
  end

end
