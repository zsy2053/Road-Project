CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = Rails.configuration.x.fog_configuration
  config.fog_directory  = ENV['S3_BUCKET_NAME']                                 # required
  config.fog_public     = false                                                 # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  config.fog_use_ssl_for_aws = true
end




