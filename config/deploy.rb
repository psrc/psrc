set :application, "psrc"

task :staging do
  set :rails_env, "staging"
  set :deploy_to, "/data/psrc-staging"
end

task :production do
  set :rails_env, "production"
  set :deploy_to, "/data/psrc"
end

set :repository,  "git@github.com:joevandyk/psrc.git"
set :scm, :git
set :ssh_options, { :forward_agent => true }
set :user, 'monkey'
set :deploy_via, :remote_cache
set :use_sudo, false
role :app, "ec2.fixieconsulting.com"
role :web, "ec2.fixieconsulting.com"
role :db,  "ec2.fixieconsulting.com", :primary => true


namespace :deploy do
  task :restart, :roles => :app do
    invoke_command "touch #{release_path}/tmp/restart.txt"
  end

  task :after_update_code, :roles => [:app] do
    run "ln -nfs #{release_path}/config/database.postgresql.yml #{ release_path }/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{ release_path }/public/assets"
  end
end
