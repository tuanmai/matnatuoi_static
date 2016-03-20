class Order < ActiveRecord::Base
  has_and_belongs_to_many :customers

  after_create :set_name

  private
  def set_name
    update_attribute(:name, "Tuần #{Order.count}")
  end
end
