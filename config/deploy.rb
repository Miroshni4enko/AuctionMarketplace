# Change the 'YOUR_AZURE_VM_IP' to the publicIpAddress from the output of
lock '3.11.0'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default value for :format is :pretty
set :format, :pretty


# Change the YOUR_GITHUB_NAME to your github user name
set :scm, :git
set :repo_url, 'git@github.com:Miroshni4enko/AuctionMarketplace.git'
set :application, 'AuctionMarketplace'
set :deploy_user, 'auctionmarketplacevm'

# files we want symlinking to specific entries in shared.
set :linked_files, %w{config/database.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.example.yml
  log_rotation
  monit
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

#files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
    {
        source: "nginx.conf",
        link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
    },
    {
        source: "unicorn_init.sh",
        link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
    },
    {
        source: "log_rotation",
        link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
    },
    {
        source: "monit",
        link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
    }
])


namespace :deploy do
  task :copy_config do
    on release_roles :app do |role|
      fetch(:linked_files).each do |linked_file|
        user = role.user + "@" if role.user
        hostname = role.hostname
        linked_files(shared_path).each do |file|
          run_locally do
            execute :rsync, "config/#{file.to_s.gsub(/.*\/(.*)$/, "\\1")}", "#{user}#{hostname}:#{file.to_s.gsub(/(.*)\/[^\/]*$/, "\\1")}/"
          end
        end
      end
    end
  end

  task :symlink_secrets do
    on roles(:app) do
      execute "rm -rf #{release_path}/config/secrets.yml"
      execute "ln -nfs ~/secrets.yml #{release_path}/config/secrets.yml"
    end
  end

  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations
  # we've added
  #after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'


  before "deploy:check:linked_files", "deploy:copy_config"
  after :finishing, :symlink_secrets
end