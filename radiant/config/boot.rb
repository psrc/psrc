# Don't change this file. Configuration is done in config/environment.rb and config/environments/*.rb

unless defined?(RAILS_ROOT)
  root_path = File.join(File.dirname(__FILE__), '..')

  unless RUBY_PLATFORM =~ /mswin32/
    require 'pathname'
    root_path = Pathname.new(root_path).cleanpath(true).to_s
  end

  RAILS_ROOT = root_path
end

unless defined? RADIANT_ROOT 
  if File.directory?(root_path = "#{RAILS_ROOT}/vendor/radiant")
    RADIANT_ROOT = root_path
  else
    RADIANT_ROOT = RAILS_ROOT
  end
end

unless defined? Radiant::Initializer
  (
    ["#{RADIANT_ROOT}/lib", "#{RADIANT_ROOT}/vendor"] +
    Dir["#{RADIANT_ROOT}/vendor/rails/*/lib"] +
    Dir["#{RADIANT_ROOT}/vendor/*/lib"]
  ).reverse_each do |path|
    $LOAD_PATH.unshift path
  end
  $LOAD_PATH.uniq!
  require 'radiant'
  require 'radiant/initializer'
  Radiant::Initializer.run(:set_load_path)
end