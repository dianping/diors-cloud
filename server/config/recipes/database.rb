namespace :db do
  desc "Setup DB configuration"
  task :setup, roles: :db do
    run "mkdir -p #{shared_path}/config"
    template "database.yml.erb", "#{shared_path}/config/database.yml"
  end
end
