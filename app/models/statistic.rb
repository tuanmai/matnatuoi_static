class Statistic < ActiveRecord::Base
  DEFAULT_TAGS = {
    employee_1_tag: 'ngo',
    employee_2_tag: 'py',
    employee_3_tag: 'anh',
    employee_4_tag: 't'
  }
  belongs_to :week
  
  before_validation :set_default_tags

  private
  def set_default_tags
    self.attributes = default_tags_with_week.merge(self.attributes.compact)
  end

  def default_tags_with_week
    return DEFAULT_TAGS unless week.try(:order_label)
    DEFAULT_TAGS.inject({}) do |rs, (key, value)|
      rs[key] = "#{value} #{week.order_label}"
      rs
    end
  end
end
