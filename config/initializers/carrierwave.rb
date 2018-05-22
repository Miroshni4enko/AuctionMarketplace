
# frozen_string_literal: true

CarrierWave.configure do |config|
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
  # These permissions will make dir and files available only to the user running
  # the servers
  # This avoids uploaded files from saving to public/ and so
  # they will not be available for public (non-authenticated) downloading

end
