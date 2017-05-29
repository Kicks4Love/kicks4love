# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "kicks4love"
set :repo_url, "https://github.com/Kicks4Love/kicks4love.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, "deploy"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/alidata/www/kicks4love"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
	desc "Fix permission"
   	task :fix_permissions, :roles => [:app, :db, :web] do
     	run "#{try_sudo} chmod -R 777 #{current_path}/tmp"
     	run "#{try_sudo} chmod -R 777 #{current_path}/public/uploads"
   	end
end

after "deploy:finalize_update", :fix_permissions