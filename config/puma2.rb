# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 4, 8

root_dir = File.expand_path("../../../..", __FILE__)
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{root_dir}/shared"

directory = app_dir
rackup "#{app_dir}/config.ru"
daemonize
#preload_app!

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
#activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
  #ActiveRecord::Base.establish_connection
end

