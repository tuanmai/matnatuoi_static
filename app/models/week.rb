class Week < ActiveRecord::Base
  has_and_belongs_to_many :orders
  has_many :customers, through: :orders
  has_many :products

  after_create :set_name

  def attributes_for_copy
    customers.map(&:attributes_for_copy).join("&#10;").html_safe
  end

  private
  def set_name
    update_attribute(:name, "Tuần #{Week.count}")
  end
end
