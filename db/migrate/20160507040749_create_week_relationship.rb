class CreateWeekRelationship < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :customer
      t.integer :num_of_weeks
      t.boolean :active, default: false

      t.timestamps
    end

    create_table :orders_weeks, id: false do |t|
      t.belongs_to :week, index: true
      t.belongs_to :order, index: true
    end
  end
end
