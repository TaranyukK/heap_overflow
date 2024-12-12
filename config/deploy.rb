# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "heap_overflow"
set :repo_url, "git@github.com:TaranyukK/heap_overflow.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/heap_overflow'
set :deploy_user, 'deploy'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"
