ActiveAdmin.register Week do
  config.sort_order = 'created_at_desc'
  config.paginate = false

  permit_params :name, :status, :order_label

  filter :name

  index do
    column :name, sortable: true do |name|
      best_in_place name, :name, as: :input, url: [:activeadmin, name]
    end
    column :status, sortable: true do |status|
      best_in_place status, :status, as: :select, collection: Week.statuses.map { |s| [s[0], s[0].humanize] }, url: [:activeadmin, status]
    end
    column :order_label, sortable: true do |order_label|
      best_in_place order_label, :order_label, as: :input, url: [:activeadmin, order_label]
    end

    actions
  end

end
