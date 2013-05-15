namespace :diors do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "diors.yml.erb", "#{shared_path}/config/diors.yml"
  end
  after "deploy:setup", "diors:setup"
end
