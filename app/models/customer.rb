require 'csv'
class Customer < ActiveRecord::Base
  extend Importer::Csv::ClassMethods

  has_one :facebook_user, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :weeks, through: :orders

  before_save :remove_newline_in_note

  class << self
    def attributes_from_csv_row(row, parent)
      {
        position: row['STT'],
        name: row['Tên'],
        address: row['Địa chỉ'],
        phone_number: row['Số DT'],
        skin_type: row['Loại Da'],
        allergy: row['Dị ứng'],
        note: [row['Note'], row['Note 2'], row['Note 3']].compact.join("; "),
        prefer: row['Prefer'],
        combo: row['Gói'],
        facebook_name: row['Facebook Name'],
      }
    end

    def new_or_update_from_csv(attrs)
      if attrs[:position].present? && attrs[:name].present?
        customer = Customer.where(name: attrs[:name], position: attrs[:position]).first_or_initialize
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

  def add_order_week(week, num_of_weeks = 1)
    order = first_or_create_active_order(num_of_weeks)
    order.weeks << week unless order.weeks.include?(week)
    order
  end

  def remove_order_week(week)
    if active_order
      active_order.weeks.delete(week)
    end
    active_order
  end

  def first_or_create_active_order(num_of_weeks = 1)
    @active_order ||= self.orders.where(active: true).first_or_create do |order|
      order.active = true
      order.num_of_weeks = num_of_weeks
    end
  end

  def active_order
    @active_order ||= self.orders.where(active: true).first
  end

  def name_and_phone_number
    "#{name} - #{phone_number}"
  end

  def add_note(note)
    self.note ||= ""
    self.note += "#{note}" unless self.note.include?(note)
    self.save
  end

  def attributes_for_ship
    ship_note = [ship_time, note].join(';')
    [name, phone_number, address, district, price, ship_note].join("&#09;").html_safe
  end

  def attributes_for_customer_data
    [position, name, skin_type, allergy, prefer, phone_number, address, price, ship_time, note, facebook_name, facebook_id].join("&#09;").html_safe
  end

  def remove_newline_in_note
    self.note = self.note.gsub("\n", ' ') if self.note.present?
  end
end
