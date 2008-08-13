# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com

require "eycap/recipes"

# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The :deploy_to variable must be the root of the application.

set :keep_releases,       5
set :application,         "psrc"
set :repository,          "github-psrc:joevandyk/psrc.git"
set :user,                "tanga"
set :deploy_to,           "/data/#{application}"
set :password,            "k31bv4j3"

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, 			lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

set :monit_group,         "psrc"
set :scm,                 :git
set :runner,							"tanga"

set :production_database, "psrc_production"
set :production_dbhost,   "psql82-2-master"

set :dbuser,        "tanga_db"
set :dbpass,        "lb31v12j"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false


# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

  
  
task :production do

  role :web, "74.201.254.36:8372" # tanga_staging [thin,memcached,backgroundrb] [psql82-staging-1] and psrc [thin] [psql82-2-master]
  role :app, "74.201.254.36:8372", :thin => true, :memcached => true, :backgroundrb => true
  role :db , "74.201.254.36:8372", :primary => true
  
  
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

# =============================================================================
# Any custom after tasks can go here.
# after "deploy:symlink_configs", "psrc_custom"
# task :psrc_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
#   run <<-CMD
#   CMD
# end
# =============================================================================

# Do not change below unless you know what you are doing!


task "extensions_migrations", :roles => :db, :except => {:no_release => true, :no_symlink => true} do
  run <<-CMD
    cd #{current_path} && RAILS_ENV=production rake db:migrate:extensions
  CMD
end

after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"
after "deploy:migrations", "extensions_migrations"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"
