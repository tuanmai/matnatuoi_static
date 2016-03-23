namespace :import_csv do
  desc "Import csv for Customer"
  task :import_customer => :environment do |t|
    csv_text = File.read(Rails.root.join("Mat na tuoi - Khach Hang.csv"))
    Customer.create_from_csv(csv_string: csv_text)
  end
end
