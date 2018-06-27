# Change the 'YOUR_AZURE_VM_IP' to the publicIpAddress from the output of
lock '3.11.0'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default value for :format is :pretty
set :format, :pretty


# Change the YOUR_GITHUB_NAME to your github user name
set :repo_url, 'git@github.com:Miroshni4enko/AuctionMarketplace.git'
set :application, 'AuctionMarketplace'
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :ssh_options, {forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub)}
set :pty, true
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache
set :nginx_application_name, "#{fetch :application}"
set :app_server_socket, "/home/auctionmarketplacevm/apps/AuctionMarketplace/current/tmp/pids/unicorn.pid"


desc 'Invoke a rake command on the remote server'
task :invoke, [:command] => 'deploy:set_rails_env' do |_task, args|
  on primary(:app) do
    within current_path do
      with rails_env: fetch(:rails_env) do
        rake args[:command]
      end
    end
  end
end

namespace :deploy do
  after :restart, :clear_cache do
    invoke 'unicorn:restart'
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

  after :publishing, :restart
  after :finishing, :cleanup
  before :finishing, :restart
  after :rollback, :restart

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

  before "deploy:check:linked_files", "deploy:copy_config"
  after :finishing, :symlink_secrets
end

=begin
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "/tmp/pids/puma.state"
set :puma_pid,        "/tmp/pids/puma.pid"
set :puma_access_log, "/log/puma.error.log"
set :puma_error_log,  "/log/puma.access.log"

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
=end

=begin
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end
=end

=begin
namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      #
      # The capistrano-unicorn-nginx gem handles all this
      # for this example
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :symlink_secrets
  after  :finishing,    :cleanup
end
=end


# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma