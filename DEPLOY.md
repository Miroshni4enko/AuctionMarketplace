* connect to server via ssh
  
* install Nginx

  sudo apt update
  sudo apt install nginx

* don't install documentation with gems

  echo "gem: --no-rdoc --no-ri" > ~/.gemrc

* add RVM's key

  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

* install RVM w/ Rails support
  
  curl -sSL https://get.rvm.io | bash -s stable --rails
  source ~/.rvm/scripts/rvm
  rvm requirements

* add a production Rails secret -- this should not be public

  printf "production:\n  secret_key_base: a9745e5b12014e7a9405c0feda86add32e0ce755661f6c118f2a6089ef0025590a70ebc173ae6906ee303fd0f2e9bff701a8a9c19328d67faefdd525ead7e4ec\n" > ~/secrets.yml

* install postgresql
 
  sudo apt-get install postgresql postgresql-contrib libpq-dev
  
* create db user
 
  sudo -u postgres createuser -s pguser
  sudo -u postgres psql
  postges=* \password pguser
  postges=* \q
  Add this user to database.yml

* install Redis for Sidekiq
  
  Can get instruction from
   - https://askubuntu.com/questions/868848/how-to-install-redis-on-ubuntu-16-04
   - https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
  
* change configuration for deployment

  - server_name
  - user
  - deploy_user
 
* add configuration files for third parties(optional if needed)
  
  - add to set(:config_files - which config files should be copied by deploy:setup_config
    see documentation in lib/capistrano/tasks/setup_config.cap
    for details of operations
    can add monit or orher libs
  - add to set(:executable_config_files - which config files should be made executable after copying
    by deploy:setup_config
  For more info see http://www.talkingquickly.co.uk/2014/01/deploying-rails-apps-to-a-vps-with-capistrano-v3/

* commit all of our changes and push them to the Github

  git add .
  git commit -am 'deploy'
  git push origin master

* use capistrano commands to deploy project

  - cap production deploy:setup_config  
  - in output can see check for nginx configuration
    if can't notice, do it manual 
      - ps -ef | grep nginx #where nginx is located,
      - {location of nginx}/nginx -t # run it and can see errors in config if they exist
  - cap production deploy  #some of command can failed, keep calm 

* restart nginx and unicorn
 
  - sudo service unicorn restart
  - sudo service unicorn status
  - sudo service nginx restart
  - sudo service nginx status
  
* to see nginx and unicorn config use
 
  - vi /etc/init.d/unicorn_AuctionMarketplace_production
  - vi /etc/nginx/sites-enabled/AuctionMarketplace_production
  
* project location
 
  - /home/{server_user}/apps/AuctionMarketplace_production/current
  