# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

app_path = "/home/deploy/TrustAuth/current"
cap_root = "/home/deploy/TrustAuth"
app_shared = "#{cap_root}/shared"

working_directory "#{app_path}"
listen 2007, :tcp_nopush => true # by default Unicorn listens on port 8080
timeout 30
user "deploy", "deploy"
worker_processes 4 # this should be >= nr_cpus
pid "#{app_shared}/pids/unicorn.pid"
stderr_path "#{app_shared}/log/unicorn.log"
stdout_path "#{app_shared}/log/unicorn.log"
