module Sync
  class FacebookStatistic
    PRODUCT_TAGS = {
      B: 'bạc hà',
      C: 'combo',
      D: 'dưa leo',
      DD: 'dâu',
      TV: 'trong veo',
      DG: 'dầu gội',
      S: 'sexy'
    }
    attr_accessor :week, :statistic

    def initialize(week_id)
      @week = Week.find week_id
      if @week.statistic.nil?
        @statistic = @week.build_statistic
        @statistic.save
      else
        @statistic = @week.statistic
      end
    end

    def call
      data = calculate_total_count
      month_data = calculate_month_data
      data.each do |employee_tag, values|
        employee_position_tag = employee_tags.select {|k,v| v == employee_tag}.keys.first
        employee_position = employee_position_tag[9]
        statistic.send("employee_#{employee_position}_total_products=",result_as_text(values))
      end
      data[:month] = month_data
      statistic.log = data
      statistic.save
    end

    def result_as_text(data)
      total = 0
      detail = data.slice(*PRODUCT_TAGS.keys).map do |tag, count|
        total += count
        "#{count} #{PRODUCT_TAGS[tag]}"
      end.join(",")
      "#{detail}. Tổng: #{total}"
    end

    def calculate_month_data
      result = {}
      FacebookPageToken.all.map do |page|
        FbPageApi.admin_notes(parent_id: page.page_id, page_access_token: page.access_token).collection.each do |note|
          employee_tags.map do |_, employee|
            employee_tag = employee.match(/[a-zA-Z]+/).to_s
            month_regex = /(start|Start)( )*(\(( )*(#{employee_tag})( )*\))( )*-( )*#{week.order_label}( )*-( )*\d/i
            month_note = note['body'].match(month_regex).to_s
            next unless month_note
            count = month_note.last.to_i
            result[employee] ||= 0
            result[employee] += count
          end
        end
      end
      result
    end

    def calculate_total_count
      result = {}
      FacebookPageToken.all.map do |page|
        labels = fb_labels(page)
        week_labels = labels.select {|label| label['name'].match(/#{week.order_label}/) }

        users_by_employees = employee_tags.map do |_, tag|
          employee_week_label = week_labels.find {|label| label['name'].match(/#{tag}/i) }
          next unless employee_week_label
          next unless fb_client(page).get(employee_week_label['id'])['users']
          if employee_week_label
            {
              employee_tag: tag,
              users: fb_client(page).get(employee_week_label['id'])['users']['data'].map {|user| user['id']}
            }
          end
        end

        PRODUCT_TAGS.keys.each do |tag|
          product_tag_for_week = "#{tag}#{week.order_label}"
          product_labels = week_labels.select {|label| label['name'].match(/^#{product_tag_for_week}/i)}
          product_labels.each do |label|
            label_name = label['name']
            if label_name.match(/^#{product_tag_for_week}-/i)
              multiplier = label_name.upcase.gsub("#{product_tag_for_week}-", "").to_i
            else
              multiplier = 1
            end
            fb_label_data = fb_client(page).get(label['id'])
            next unless fb_label_data['users']
            users = fb_label_data['users']['data'].map {|user| user['id']} 
            users_by_employees.each do |employee|
              if employee
                result[employee[:employee_tag]] ||= {}
                result[employee[:employee_tag]][label_name] ||= 0
                result[employee[:employee_tag]][label_name] += (employee[:users] & users).count
                result[employee[:employee_tag]][tag] ||= 0
                result[employee[:employee_tag]][tag] += (employee[:users] & users).count * multiplier
              end
            end
          end
        end
      end
      result
    end

    private
    def fb_labels(page)
      FbPageApi.labels(parent_id: page.page_id, page_access_token: page.access_token).collection
    end

    def fb_client(page)
      FbPageApi.labels(parent_id: page.page_id, page_access_token: page.access_token, custom_request_fields: ['users'])
    end

    def employee_tags
      statistic.attributes.with_indifferent_access.slice(:employee_1_tag, :employee_2_tag, :employee_3_tag,
                                                         :employee_4_tag, :employee_5_tag, :employee_6_tag).compact
    end
  end
end
