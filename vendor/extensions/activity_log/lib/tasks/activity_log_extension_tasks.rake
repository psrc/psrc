namespace :radiant do
  namespace :extensions do
    namespace :mailer do
      
      desc "Runs the migration of the Activity Log extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ActivityLogExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ActivityLogExtension.migrator.migrate
        end
      end
    end
  end
end
