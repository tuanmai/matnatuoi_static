class Statistic < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.belongs_to :week
      t.string :employee_1_tag
      t.string :employee_1_total_products
      t.string :employee_2_tag
      t.string :employee_2_total_products
      t.string :employee_3_tag
      t.string :employee_3_total_products
      t.string :employee_4_tag
      t.string :employee_4_total_products
      t.string :employee_5_tag
      t.string :employee_5_total_products
      t.string :employee_6_tag
      t.string :employee_6_total_products
      t.string :log

      t.timestamps null: false
    end
  end
end
