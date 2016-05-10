class AddStatusToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :status, :integer, default: 0
    remove_column :weeks, :active
  end
end
