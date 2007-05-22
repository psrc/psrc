namespace :radiant do
  namespace :extensions do
    namespace :fuzzy_bears do
      
      desc "Runs the migration of the Fuzzy Bears extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FuzzyBearsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FuzzyBearsExtension.migrator.migrate
        end
      end
    
    end
  end
end