set :rvm_ruby_version, '2.4.3@AuctionMarketplace'
# use the master branch of the repository
set :branch, "master"
set :user, 'auctionmarketplacevm'
# the user login on the remote server
# the 'full name' of the application
# the server(s) to deploy to
set :rails_env, :production
set :unicorn_rack_env, 'production'
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :unicorn_config_path, -> { File.join(current_path, 'config', 'unicorn', 'production.rb') }
set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }

server '40.76.218.100', user: 'auctionmarketplacevm', roles: %w{web app db}, primary: true
# the path to deploy to
# set to production for Rails
