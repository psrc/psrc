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
  desc "Runs tests on all available Radiant extensions, pass EXT=extension_name to test a single extension"
  task :extensions => "db:test:prepare" do
    extension_roots = Radiant::ExtensionLoader.instance.extension_roots
    if ENV["EXT"]
      extension_roots = extension_roots.select {|x| /\/(\d+_)?#{ENV["EXT"]}$/ === x }
      if extension_roots.empty?
        puts "Sorry, that extension is not installed."
      end
    end
    extension_roots.each do |directory|
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