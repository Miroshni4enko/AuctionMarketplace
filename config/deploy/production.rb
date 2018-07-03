set :rvm_ruby_version, '2.4.3@AuctionMarketplace'
# use the master branch of the repository
set :branch, "master"
set :user, 'auctionmarketplacevm'
# the user login on the remote server
# the 'full name' of the application
# the server(s) to deploy to
set :rails_env, :production
set :stage, :production
set :unicorn_rack_env, 'production'
set :server_name, "auctionmarketplace.eastus.cloudapp.azure.com"
server 'auctionmarketplace.eastus.cloudapp.azure.com', user: 'auctionmarketplacevm', roles: %w{web app db}, primary: true
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"
set :unicorn_config_path, -> { File.join(current_path, 'config', 'unicorn', 'production.rb') }
set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }
set :unicorn_worker_count, 5
# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false

# the path to deploy to
# set to production for Rails
