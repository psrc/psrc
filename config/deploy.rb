set :application, "psrc"
set :branch, "master"

task :staging do
  set :rails_env, "staging"
  set :deploy_to, "/data/psrc-staging"
end

task :production do
  set :rails_env, "production"
  set :deploy_to, "/data/psrc"
end

set :repository,  "git@git.fixieconsulting.com:psrc.git"
set :scm, :git
set :ssh_options, { :forward_agent => true }
set :user, 'monkey'
#set :deploy_via, :remote_cache
set :use_sudo, false
role :app, "ec2.fixieconsulting.com"
role :web, "ec2.fixieconsulting.com"
role :db,  "ec2.fixieconsulting.com", :primary => true


namespace :deploy do
  task :restart, :roles => :app do
    invoke_command "touch #{current_path}/tmp/restart.txt"
  end

  task :after_update_code, :roles => [:app] do
    run "ln -nfs #{current_path}/config/database.postgresql.yml #{ current_path }/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{ current_path }/public/assets"
  end

  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
  end 
end
