
# frozen_string_literal: true

CarrierWave.configure do |config|

  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false

  config.cache_dir = "#{Rails.root}/tmp/uploads"

  if Rails.env.production?
    # config.storage :fog
    # config.fog_credentials = {}
  elsif Rails.env.development?
    config.storage :file

  elsif Rails.env.test?
    config.storage :file
    # Required to prevent FactoryGirl from giving an infuriating exception
    # ArgumentError: wrong exec option
    # It also speeds up tests so it's a good idea
    config.enable_processing = false
  end

end
