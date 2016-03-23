require 'csv'
class Customer < ActiveRecord::Base
  extend Importer::Csv::ClassMethods

  has_and_belongs_to_many :orders

  after_save :destroy_object

  def destroy_object
    raise ''
  end

  def name_and_phone_number
    "#{name} - #{phone_number}"
  end

  def attributes_for_copy
    [name, phone_number, address, ship_time, price].join("&#09;").html_safe
  end

  def self.attributes_from_csv_row(row, parent)
    {
      name: row['Tên'],
      address: row['Địa chỉ'],
      phone_number: row['Số DT'],
      skin_type: row['Loại Da'],
      allergy: row['Dị ứng'],
      note: row['Note'],
      prefer: row['Prefer'],
      combo: row['Gói'],
    }
  end
end
