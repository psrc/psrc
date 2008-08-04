namespace :radiant do
  namespace :extensions do
    namespace :event_registrations do
      
      desc "Runs the migration of the Event Registrations extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          EventRegistrationsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          EventRegistrationsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Event Registrations to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[EventRegistrationsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(EventRegistrationsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
