namespace :radiant do
  namespace :extensions do
    namespace :personnel_directory do
      
      desc "Runs the migration of the Personnel Directory extension"
      task :migrate do
        require 'extension_migrator'
        PersonnelDirectoryExtension.migrator.migrate
      end
    
    end
  end
end