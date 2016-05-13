class Order < ActiveRecord::Base
  belongs_to :customer
  has_and_belongs_to_many :weeks

  # before_save :update_active_order_of_customer

  private
  #
  # def update_active(week = nil)
  #   if self.weeks.where(status: Week.statuses[:closed]).count >= self.num_of_weeks
  #     self.active = false
  #     self.save
  #   end
  # end

  def update_active_order_of_customer
    if self.active
      self.customer.orders.where.not(id: self.id).update_all(active: false)
    end
    true
  end
end
