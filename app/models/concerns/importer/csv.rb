module Importer
  module Csv
    class Response
      attr_accessor :success, :message, :resource
      def initialize(success, message, resource = nil)
        @success = success
        @message = message
        @resource = resource
      end
    end

    module ClassMethods
      def create_from_csv(parent: parent, csv_string: csv_string)
        if csv_string.blank?
          Importer::Csv::Response.new(false, "Invalid CSV file")
        else
          collection = []
          errors = []

          begin
            rows = ::CSV.parse(csv_string, headers: true)
          rescue ::CSV::MalformedCSVError => e
            rows = []
            errors << "Malformed CSV: #{e.message}"
          end

          rows.each_with_index do |row, index|
            if row.present?
              resource = new_or_update_from_csv(attributes_from_csv_row(row, parent))
              if resource
                if resource.valid?
                  collection << resource
                else
                  errors << "Row #{index + 2}: #{resource.errors.full_messages.join(', ')}"
                end
              end
            else
              errors << "Row #{index + 2} is missing"
            end
          end

          if errors.blank?
            collection.map(&:save)
            Importer::Csv::Response.new(true, "Successfully imported #{rows.size} #{'item'.pluralize(rows.size)} from CSV")
          else
            Importer::Csv::Response.new(false, errors.join('. '))
          end
        end
      end

      def new_or_update_from_csv(attrs)
        new(attrs) if attrs.present?
      end
    end
  end
end
