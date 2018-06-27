# Set up socket location
listen "#/sockets/unicorn.sock", :backlog => 64


# frozen_string_literal: true
# Set the working application directory
working_directory '/home/auctionmarketplacevm/apps/AuctionMarketplace/current'

# Unicorn PID file location
pid '/home/auctionmarketplacevm/apps/AuctionMarketplace/current/tmp/pids/unicorn.pid'

# Path to logs
stderr_path '/home/auctionmarketplacevm/apps/AuctionMarketplace/current/log/unicorn.log'
stdout_path '/home/auctionmarketplacevm/apps/AuctionMarketplace/current/log/unicorn.log'

# Number of processes
worker_processes 2

# Time-out
timeout 30
preload_app true