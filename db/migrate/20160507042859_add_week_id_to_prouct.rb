class AddWeekIdToProuct < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.belongs_to :week, index: true
    end
  end
end
