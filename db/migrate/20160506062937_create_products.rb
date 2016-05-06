class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :order
      t.string :name
      t.text :sort_description
      t.text :description
      t.string :image_url
      t.string :product_url
      t.string :product_payload_code

      t.timestamps null: false
    end
  end
end
