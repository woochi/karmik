# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'karmik'
set :repo_url, 'git@github.com:woochi/karmik.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/karmik'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Default gulp task is empty (i.e. 'gulp')
# set :gulp_tasks, 'deploy:production'
set :gulp_file, -> { release_path.join('gulpfile.js') }
set :gulp_tasks, 'deploy'

# Npm defaults
set :npm_flags, '--production --silent --no-spin'

namespace :server do

  task :delete do
    on roles(:web) do
      within fetch(:deploy_to) do
        execute "cd #{release_path} && pm2 delete www"
      end
    end
  end

  task :start do
    on roles(:web) do
      within fetch(:deploy_to) do
        execute "cd #{release_path} && NODE_ENV=production pm2 start bin/www.coffee"
      end
    end
  end

  task :restart do
    on roles(:web) do
      within fetch(:deploy_to) do
        execute "cd #{release_path} && NODE_ENV=production pm2 restart www"
      end
    end
  end

  task :stop do
    on roles(:web) do
      within fetch(:deploy_to) do
        execute "cd #{release_path} && NODE_ENV=production pm2 stop www"
      end
    end
  end

end

namespace :deploy do

  before :updated, 'gulp'
  after :updated, "server:delete"
  after :updated, "server:start"

end
