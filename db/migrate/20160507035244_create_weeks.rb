class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.string :name
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
