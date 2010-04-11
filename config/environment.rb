# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Ruby 1.8.7 adds a chars method, which returns an enumerator object.
# But Rails 2.0.2 expects a ActiveSupport::Multibyte::Chars object.
# So we remove that method.
unless '1.9'.respond_to?(:force_encoding)
  String.class_eval do
    begin
      remove_method :chars
    rescue NameError
      # OK
    end
  end
end

# Specifies gem version of Rails to use when vendor/rails is not present
require File.join(File.dirname(__FILE__), 'boot')

require 'rubygems'
require 'radius'
require 'RedCloth' # version 4.1.0
require 'postgres' # not compatible with pg 0.9, I think

Radiant::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  #config.frameworks = [ :action_mailer ]
  
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # Only load the extensions named here, in the order given. By default all 
  # extensions in vendor/extensions are loaded, in alphabetical order. :all 
  # can be used as a placeholder for all extensions not explicitly named. 
  # config.extensions = [ :all ] 

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
  
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_psrc_#{RAILS_ENV}',
    :secret      => 'asdfqwerfxcoivswqenadfasdfqewpfioutyqwel'
  }
    config.action_controller.allow_forgery_protection = false
  
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
  
  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  # config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/fragment_cache"
  config.action_controller.page_cache_directory = "#{RAILS_ROOT}/cache"
  
  # Activate observers that should always be running
  config.active_record.observers = :user_action_observer

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  # Set the default field error proc
  config.action_view.field_error_proc = Proc.new do |html, instance|
    %{<div class="error-with-field">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}
  end
  
  config.after_initialize do
    if ActiveRecord::Base.connection.tables.include?('config') #Without this, you won't be able to bootstrap a clean instance
      # Radiant Options
      Radiant::Config['admin.title'] = "Puget Sound Regional Council" if Radiant::Config['admin.title'] =~ /Radiant CMS/
      Radiant::Config['admin.subtitle'] = "Control Panel" if Radiant::Config['admin.subtitle'] =~ /Publishing for Small Teams/
      Radiant::Config['defaults.page.filter'] = "Textile"
      Radiant::Config['defaults.page.status'] = 'published' if Radiant::Config['defaults.page.status'] =~ /draft/
      Radiant::Config['debug?'] = true

      # Add new inflection rules using the following format:
      Inflector.inflections do |inflect|
        inflect.uncountable 'config'
        inflect.uncountable 'meta'
      end

      # Auto-require text filters
      Dir["#{RADIANT_ROOT}/app/models/*_filter.rb"].each do |filter|
        require_dependency File.basename(filter).sub(/\.rb$/, '')
      end

      # Response Caching Defaults
      ResponseCache.defaults[:directory] = ActionController::Base.page_cache_directory
      ResponseCache.defaults[:logger]    = ActionController::Base.logger
    end
  end
end

HoptoadNotifier.configure do |config|
   config.api_key = '9786b95cf10aa5b13c9ddc78432dd55d'
end
