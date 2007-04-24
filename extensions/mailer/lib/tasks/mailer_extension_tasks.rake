namespace :radiant do
  namespace :extensions do
    namespace :mailer do
      
      desc "Runs the migration of the Mailer extension"
      task :migrate do
        require 'extension_migrator'
        MailerExtension.migrator.migrate
      end
    
    end
  end
end