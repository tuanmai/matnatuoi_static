class AddNoteIdToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :note_id, :string
    add_column :customers, :note_body, :string
    add_column :customers, :note_data, :text
  end
end
