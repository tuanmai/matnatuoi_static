if Rails.env == 'test'
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
        :provider               => 'AWS',
        :aws_access_key_id      => ENV['s3_access_key'],
        :aws_secret_access_key  => ENV['s3_secret_key'],
        :region                 => EMV['s3_region'] # Change this for different AWS region. Default is 'us-east-1'
    }
    config.fog_directory  = ENV['s3_bucket']
  end
end
