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

set :repository,  "git@git.fixieconsulting.com:psrc.git"
set :scm, :git
set :ssh_options, { :forward_agent => true }
set :user, 'deploy'
#set :deploy_via, :remote_cache
set :use_sudo, false
role :app, "bbg.psrc.org"
role :web, "bbg.psrc.org"
role :db,  "bbg.psrc.org", :primary => true


namespace :deploy do
  task :restart, :roles => :app do
    invoke_command "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink do
    run "mkdir -p #{current_path}/tmp"
  end # Don't symlink

  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
    run "ln -nfs #{current_path}/config/database.postgresql.yml #{ current_path }/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{ current_path }/public/assets"
  end 

  task :after_setup, :roles => [:app] do
    run "cd #{shared_path}/..; git clone #{repository} current"
  end
end
