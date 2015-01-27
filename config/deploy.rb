set :application, "psrc"
set :branch, "master"

task :staging do
  set :rails_env, "staging"
  set :deploy_to, "/sites/psrc-staging"
end

task :production do
  set :rails_env, "production"
  set :deploy_to, "/sites/psrc-production"
end

set :repository,  "git@github.com:psrc/psrc.git"
set :scm, :git
set :ssh_options, { :forward_agent => true }
set :user, 'deploy'
set :deploy_via, :remote_cache
set :use_sudo, false
role :app, "bbg.psrc.org"
role :web, "bbg.psrc.org"
role :db,  "bbg.psrc.org", :primary => true

after 'deploy:update_code', 'deploy:additional_symlinks'

namespace :deploy do
  task :restart, :roles => :app do
    run "mkdir -p #{current_path}/tmp"
    invoke_command "touch #{current_path}/tmp/restart.txt"
  end
  
  task :additional_symlinks do
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/config/*.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/htaccess #{release_path}/public/.htaccess"
  end
end
