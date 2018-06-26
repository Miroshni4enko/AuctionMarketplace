# frozen_string_literal: true
# Set the working application directory
working_directory '/home/auctionmarketplacevm/apps/AuctionMarketplace'

# Unicorn PID file location
pid '/home/auctionmarketplacevm/apps/AuctionMarketplace/tmp/pids/unicorn.pid'

# Path to logs
stderr_path '/home/auctionmarketplacevm/apps/AuctionMarketplace/log/unicorn.log'
stdout_path '/home/auctionmarketplacevm/apps/AuctionMarketplace/log/unicorn.log'

# Unicorn socket
listen 'localhost:3030'

# Number of processes
worker_processes 2

# Time-out
timeout 30
