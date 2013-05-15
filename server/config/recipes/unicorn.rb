set_default(:unicorn_user) { user }
set_default(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }
set_default(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
set_default(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
set_default(:unicorn_workers, 8)

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/#{application}"
  end
  after "deploy:setup", "unicorn:setup"

  %w[start stop restart reload].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "service #{application} #{command}"
    end
  end
end
