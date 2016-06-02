namespace :product do
  desc "recreate image version"
  task :recreate_image_versions => :environment do |t|
    Product.all.each do |p|
      p.image.recreate_versions rescue nil
    end
  end
end
