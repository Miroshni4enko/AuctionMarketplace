# Auction Marketplace

REST server for auction marketplace where people (as a sellers) can 
present their products for sale at auctions' lots from one side,
and from the other side - take part in the lots of other people (as a customers)to buy their products.

Server url - http://auctionmarketplace.eastus.cloudapp.azure.com

Rest Api documentation can find on /api_docs route 

* Ruby version
  2.4.3, gemset AuctionMarketplace (see rvm configuration) 

* System dependencies
  - install postgreSql 
  - install Reddis(Sidekiq is used for pprocessing jobs)

* Configuration
  - add config for env, see example config/properties.env.example  

* Database creation
  use approprite env(ex. test )
  - rake db:create
  - rake db:migration

* Database initialization
  - rake db:seed

* How to run the test suite
  - rspec
   
* How to regenerate docs
  - rake swagger:docs
  
* How to deploy
  see DEPLOY.md