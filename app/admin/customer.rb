ActiveAdmin.register Customer do
  config.sort_order = 'position_asc'
  config.paginate = false

  permit_params :position, :name, :skin_type, :phone_number, :address, :district, :price,
                :ship_time, :note, :facebook_id, :facebook_name

  filter :weeks
  filter :name
  filter :skin_type
  filter :phone_number
  filter :address
  filter :district

  index do
    column :position
    column :name, sortable: false do |name|
      best_in_place name, :name, as: :textarea, url: [:activeadmin, name]
    end
    column :skin_type, sortable: false do |skin_type|
      best_in_place skin_type, :skin_type, as: :textarea, url: [:activeadmin, skin_type]
    end
    column :allergy, sortable: false do |allergy|
      best_in_place allergy, :allergy, as: :textarea, url: [:activeadmin, allergy]
    end
    column :phone_number, sortable: false do |phone_number|
      best_in_place phone_number, :phone_number, as: :textarea, url: [:activeadmin, phone_number]
    end
    column :address, sortable: false do |address|
      best_in_place address, :address, as: :textarea, url: [:activeadmin, address]
    end
    column :district, sortable: :district do |district|
      best_in_place district, :district, as: :textarea, url: [:activeadmin, district]
    end
    column :ward, sortable: :ward do |ward|
      best_in_place ward, :ward, as: :textarea, url: [:activeadmin, ward]
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

    actions
  end

  csv force_quotes: true do
    column :name
    column :phone_number
    column :address
    column :district
    column :ship_time
    column :note
  end

end
