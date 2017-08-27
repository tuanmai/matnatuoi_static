ActiveAdmin.register Statistic do
  config.sort_order = 'created_at_desc'
  config.paginate = false

  permit_params :week_id, :employee_1_tag, :employee_2_tag, :employee_3_tag,
    :employee_4_tag, :employee_5_tag, :employee_6_tag

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
    actions
  end

end
