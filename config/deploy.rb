#require 'rubygems'

#load 'deploy/assets'
#require 'rvm/capistrano'
#require "bundler/capistrano"

#set :rvm_ruby_string, "deploy"
#set :rvm_type, :system
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

#set :application, "TrustAuth"
#set :repository,  "git@github.com:romaimperator/trustauth-rails-demo.git"

#set :branch, "master"
#set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#set :deploy_to, "/home/deploy/#{application}/"
#set :deploy_via, :remote_cache
#set :user, "deploy"
#set :sudo_password, "<censored>"
#default_run_options[:pty] = true

#set :default_stage, "production"
#set :stages, %w{production}

#set :use_sudo, true
#set :keep_releases, 5
#set :copy_exclude, ['.git', '.gitignore']

#ssh_options[:forward_agent] = true

#server "trustauth.com", :app, :web, :db, :primary => true
#server "173.255.227.190", :app, :web, :db, :primary => true

#namespace :deploy do
  #task :finalize_update, :roles => :app do
    #run "echo #{current_release}"
    #run "sed -i_bak \"s/<replace_me>/<censored>/\" #{current_release}/config/database.yml"
    #run "sed -i_bak \"s/<app_path>/\\/home\\/deploy\\/TrustAuth\\/current\\//\" #{current_release}/config/unicorn.rb"
  #end

  #task :restart, :roles => :app do
    #run "killall -q unicorn_rails"
    #run "cd #{current_release}"
    #run "/etc/init.d/unicorn_init stop"
    #run "/etc/init.d/unicorn_init start"
    #run "/etc/init.d/unicorn_init restart"
    #true
  #end
#end
#role :web, "trustauth.com"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

require 'mina/git'
require 'mina/bundler'
require 'mina/rbenv'
require 'mina/rails'

set :domain, 'trustauth.com'
set :user, 'deploy'
set :repository, 'https://github.com/romaimperator/trustauth-rails-demo.git'
set :deploy_to, '/home/deploy/trustauth.com'
set :rvm_path, '/usr/local/rvm/bin/rvm'
#set :pid, "/home/deploy/trustauth.com/shared/pids/unicorn.pid"
set :pid, "/home/deploy/trustauth.com/shared/pids/puma.pid"

set :shared_paths, ['config/database.yml', 'log', 'tmp']

task :environment do
  #invoke :'rvm:use[2.1.0]'
  invoke :'rbenv:load'
end

task :deploy => :environment do
  deploy do
    # Put things that prepare the empty release folder here.
    # Commands queued here will be ran on a new release directory.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    # These are instructions to start the app after it's been prepared.
    to :launch do
      invoke :'deploy:restart'
    end

    # This optional block defines how a broken release should be cleaned up.
    to :clean do
      #queue 'log "failed deployment"'
    end
  end
end

namespace "deploy" do
  task :restart do
    queue "test -s \"#{pid}\" && kill -USR2 `cat #{pid}`"
    #queue 'touch tmp/restart.txt'
  end

  desc "Rolls back the latest release"
  task :rollback => :environment do
    queue! %[echo "-----> Rolling back to previous release for instance: #{domain}"]

    # Delete existing sym link and create a new symlink pointing to the previous release
    queue %[echo -n "-----> Creating new symlink from the previous release: "]
    queue %[ls "#{deploy_to}/releases" -Art | sort | tail -n 2 | head -n 1]
    queue! %[ls -Art "#{deploy_to}/releases" | sort | tail -n 2 | head -n 1 | xargs -I active ln -nfs "#{deploy_to}/releases/active" "#{deploy_to}/current"]

    # Remove latest release folder (active release)
    queue %[echo -n "-----> Deleting active release: "]
    queue %[ls "#{deploy_to}/releases" -Art | sort | tail -n 1]
    queue! %[ls "#{deploy_to}/releases" -Art | sort | tail -n 1 | xargs -I active rm -rf "#{deploy_to}/releases/active"]

    invoke :'deploy:restart'
  end
end

