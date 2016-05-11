require 'csv'
class Customer < ActiveRecord::Base
  extend Importer::Csv::ClassMethods

  has_one :facebook_user, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :weeks, through: :orders

  class << self
    def attributes_from_csv_row(row, parent)
      {
        position: row['STT'],
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

    def new_or_update_from_csv(attrs)
      if attrs[:position].present? && attrs[:name].present?
        customer = Customer.where(name: attrs[:name]).first_or_initialize
        customer.attributes = attrs
        customer
      end
    end

    def update_from_google_drive
      google_drive = GoogleDriveExporter.instance
      sheet = google_drive.sheet_file
      worksheet = sheet.worksheet_by_title(ENV['khach_hang_sheet'])
      self.create_from_csv(csv_string: worksheet.export_as_string)
    end
  end

  def add_order_week(week)
    if active_order && !active_order.weeks.include?(week)
      active_order.weeks << week
    end
    active_order
  end

  def remove_order_week(week)
    if active_order
      active_order.weeks.delete(week)
    end
    active_order
  end

  def active_order
    @active_order ||= self.orders.where(active: true).first
  end

  def name_and_phone_number
    "#{name} - #{phone_number}"
  end

  def attributes_for_copy
    [name, phone_number, address, ship_time, price, note].join("&#09;").html_safe
  end
end
