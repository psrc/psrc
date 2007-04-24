namespace :radiant do
  namespace :extensions do
    namespace :hello_tag do
      
      desc "Runs the migration of the Hello Tag extension"
      task :migrate do
        require 'extension_migrator'
        HelloTagExtension.migrator.migrate
      end
    
    end
  end
end