namespace :radiant do
  namespace :extensions do
    namespace :forms do
      
      desc "Runs the migration of the Forms extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FormsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FormsExtension.migrator.migrate
        end
      end
    
    end
  end
end