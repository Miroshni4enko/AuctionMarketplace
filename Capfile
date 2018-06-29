# Load DSL and Setup Up Stages
require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/postgresql'
require 'capistrano/sidekiq'
require 'capistrano/nginx'

Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }