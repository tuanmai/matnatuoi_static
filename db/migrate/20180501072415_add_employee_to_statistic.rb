class AddEmployeeToStatistic < ActiveRecord::Migration
  def change
    add_column :statistics, :employee_7_tag, :string
    add_column :statistics, :employee_7_total_products, :string
    add_column :statistics, :employee_8_tag, :string
    add_column :statistics, :employee_8_total_products, :string
    add_column :statistics, :employee_9_tag, :string
    add_column :statistics, :employee_9_total_products, :string
    add_column :statistics, :employee_10_tag, :string
    add_column :statistics, :employee_10_total_products, :string
    add_column :statistics, :employee_11_tag, :string
    add_column :statistics, :employee_11_total_products, :string
    add_column :statistics, :employee_12_tag, :string
    add_column :statistics, :employee_12_total_products, :string
    add_column :statistics, :employee_13_tag, :string
    add_column :statistics, :employee_13_total_products, :string
    add_column :statistics, :employee_14_tag, :string
    add_column :statistics, :employee_14_total_products, :string
    add_column :statistics, :employee_15_tag, :string
    add_column :statistics, :employee_15_total_products, :string
  end
end
