class Week < ActiveRecord::Base
  enum status: { pending: 0, opening: 1, closed: 2 }

  has_and_belongs_to_many :orders
  has_many :customers, through: :orders
  has_many :products

  after_create :set_name

  scope :with_products, -> { joins(:products).group('weeks.id').having('count(products.id) > 0') }

  def attributes_for_ship
    customers.order(position: :asc).map(&:attributes_for_ship).join("&#10;").html_safe
  end

  def attributes_for_customer_data
    customers.order(position: :asc).map(&:attributes_for_customer_data).join("&#10;").html_safe
  end

  private
  def set_name
    update_attribute(:name, "Tuần #{Week.count}")
  end
end
