namespace :product do
  desc "recreate image version"
  task :recreate_image_versions => :environment do |t|
    Product.all.each do |p|
      begin
        p.image.recreate_versions!
      rescue Exception => e
        p e
        nil
      end
    end
  end
end
