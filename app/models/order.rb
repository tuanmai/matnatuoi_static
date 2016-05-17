class Order < ActiveRecord::Base
  belongs_to :customer
  has_and_belongs_to_many :weeks

  private

  scope :active, -> { where(active: true) }

  def update_active_order_of_customer
    if self.active
      self.customer.orders.where.not(id: self.id).update_all(active: false)
    end
    true
  end
end
