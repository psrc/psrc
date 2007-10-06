require 'rake/testtask'

namespace :db do
  namespace :migrate do
    desc "Run all Radiant extension migrations"
    task :extensions => :environment do
      require 'radiant/extension_migrator'
      Radiant::ExtensionMigrator.migrate_extensions
    end
  end
  namespace :remigrate do
    desc "Migrate down and back up all Radiant extension migrations"
    task :extensions => :environment do
      require 'highline/import'
      if agree("This task will destroy any data stored by extensions in the database. Are you sure you want to \ncontinue? [yn] ")
        require 'radiant/extension_migrator'
        Radiant::Extension.descendants.map(&:migrator).each {|m| m.migrate(0) }
        Rake::Task['db:migrate:extensions'].invoke
      end
    end
  end
end

namespace :test do
  desc "Runs tests on all available Radiant extensions"
  task :extensions => "db:test:prepare" do
    Dir["#{RAILS_ROOT}/vendor/extensions/*"].sort.select { |f| File.directory?(f) }.each do |directory|
      chdir directory do
        if RUBY_PLATFORM =~ /win32/
          system "rake.cmd test"
        else
          system "rake test"
        end
      end
    end
  end
end

# Load any custom rakefiles from extensions
[RAILS_ROOT, RADIANT_ROOT].uniq.each do |root|
  Dir[root + '/vendor/extensions/**/tasks/**/*.rake'].sort.each { |ext| load ext }
end
