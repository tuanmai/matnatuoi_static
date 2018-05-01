ActiveAdmin.register Statistic do
  config.sort_order = 'created_at_desc'
  config.paginate = false

  permit_params :week_id, 
    :employee_1_tag, :employee_2_tag, :employee_3_tag,
    :employee_4_tag, :employee_5_tag, :employee_6_tag,
    :employee_7_tag, :employee_8_tag, :employee_9_tag,
    :employee_10_tag, :employee_11_tag, :employee_12_tag,
    :employee_13_tag, :employee_14_tag, :employee_15_tag,
    :employee_1_total_products,
    :employee_2_total_products,
    :employee_3_total_products,
    :employee_4_total_products,
    :employee_5_total_products,
    :employee_6_total_products,
    :employee_7_total_products,
    :employee_8_total_products,
    :employee_9_total_products,
    :employee_10_total_products,
    :employee_11_total_products,
    :employee_12_total_products,
    :employee_13_total_products,
    :employee_14_total_products,
    :employee_15_total_products

  member_action :sync, method: :put do
    SyncFacebookStatistic.perform_async(resource.week.id)
    redirect_to :back
  end

  action_item only: :show do
    link_to 'Sync', sync_activeadmin_statistic_path(statistic), method: :put
  end


  filter :week

  index do
    column :week
    column :employee_1_tag
    column :employee_1_total_products
    column :employee_2_tag
    column :employee_2_total_products
    column :employee_3_tag
    column :employee_3_total_products
    column :employee_4_tag
    column :employee_4_total_products
    column :employee_5_tag
    column :employee_5_total_products
    column :employee_6_tag
    column :employee_6_total_products
    column :employee_7_tag
    column :employee_7_total_products
    column :employee_8_tag
    column :employee_8_total_products
    column :employee_9_tag
    column :employee_9_total_products
    column :employee_10_tag
    column :employee_10_total_products
    column :employee_11_tag
    column :employee_11_total_products
    column :employee_12_tag
    column :employee_12_total_products
    column :employee_13_tag
    column :employee_13_total_products
    column :employee_14_tag
    column :employee_14_total_products
    column :employee_15_tag
    column :employee_15_total_products
    actions
  end

end
