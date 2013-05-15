require 'sidekiq/capistrano'
load "config/recipes/base"
load "config/recipes/diors"
load "config/recipes/database"
load "config/recipes/unicorn"
load "config/recipes/nginx"

set :application, "diors-cloud"

set :user, 'diors'
set :rails_env, 'production'
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

set :scm, :git
set :deploy_via, :remote_cache
set :deploy_to, "/var/apps/#{application}"
set :repository,  "git://github.com/dianping/diors-cloud.git"

server '192.168.212.6', :app, :web, :db, :primary => true

default_run_options[:pty] = true
set :use_sudo, false

set(:latest_release) { "#{fetch(:release_path)}/server" }

namespace :deploy do
  desc 'Start the application services'
  task :start, roles: :app do
    run "#{sudo} service #{application} start"
  end

  desc 'Stop the application services'
  task :stop, roles: :app do
    run "#{sudo} service #{application} stop"
  end

  desc 'Restart the application services'
  task :restart, roles: :app do
    run "#{sudo} service #{application} restart"
  end

  desc 'Reload the application services'
  task :reload, roles: :app do
    run "#{sudo} service #{application} reload"
  end

  desc "create symlink configuration file"
  task :symlink_shared, :on_no_matching_servers => :continue do
    run "ln -nfs #{shared_path}/bundle #{release_path}/server/vendor/bundle"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/server/config/database.yml"
    run "ln -nfs #{shared_path}/config/diors.yml #{release_path}/server/config/diors.yml"
    run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/server/config/unicorn.rb"
  end

  desc "symlink hubot diors-script"
  task :hubot_link, :on_no_matching_servers => :continue do
    hubot_path = "/var/apps/diors-hubot"
    diors_coffee = "hubot-scripts/src/scripts/diors.coffee"
    run "ln -nfs #{release_path}/client/#{diors_coffee} #{hubot_path}/node_modules/#{diors_coffee}"
  end
end

before "bundle:install", "deploy:symlink_shared"
after "deploy:update", "deploy:hubot_link"
