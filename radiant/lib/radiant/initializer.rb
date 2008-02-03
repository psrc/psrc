# Add necessary Rails path
$LOAD_PATH.unshift "#{RADIANT_ROOT}/vendor/rails/railties/lib"

require 'initializer'
require 'radiant/admin_ui'
require 'radiant/extension_loader'

module Radiant

  class Configuration < Rails::Configuration
    attr_accessor :extension_paths
    attr_accessor :extensions
    attr_accessor :view_paths

    def initialize
      self.view_paths = []
      self.extension_paths = default_extension_paths
      self.extensions = [ :all ]
      super
    end

    def default_extension_paths
      env = ENV["RAILS_ENV"] || RAILS_ENV
      paths = [RADIANT_ROOT + '/vendor/extensions', RAILS_ROOT + '/vendor/extensions'].uniq
      # There's no other way it will work, config/environments/test.rb loads too late
      paths.unshift(RADIANT_ROOT + "/test/fixtures/extensions") if env == "test"
      paths
    end

    def admin
      AdminUI.instance
    end

    private

      def library_directories
        Dir["#{RADIANT_ROOT}/vendor/*/lib"]
      end

      def framework_root_path
        RADIANT_ROOT + '/vendor/rails'
      end

      # Provide the load paths for the Radiant installation
      def default_load_paths
        paths = ["#{RADIANT_ROOT}/test/mocks/#{environment}"]

        # Add the app's controller directory
        paths.concat(Dir["#{RADIANT_ROOT}/app/controllers/"])

        # Then components subdirectories.
        paths.concat(Dir["#{RADIANT_ROOT}/components/[_a-z]*"])

        # Followed by the standard includes.
        paths.concat %w(
          app
          app/models
          app/controllers
          app/helpers
          config
          lib
          vendor
        ).map { |dir| "#{RADIANT_ROOT}/#{dir}" }.select { |dir| File.directory?(dir) }

        paths.concat builtin_directories
        paths.concat library_directories
      end

      def default_plugin_paths
        [
          "#{RAILS_ROOT}/vendor/plugins",
          "#{RADIANT_ROOT}/lib/plugins",
          "#{RADIANT_ROOT}/vendor/plugins"
        ]
      end

      def default_view_path
        File.join(RADIANT_ROOT, 'app', 'views')
      end

      def default_controller_paths
        [File.join(RADIANT_ROOT, 'app', 'controllers')]
      end
  end

  class Initializer < Rails::Initializer
    def self.run(command = :process, configuration = Configuration.new)
      super
    end

    def set_load_path
      extension_loader.add_load_and_plugin_paths
      super
    end

    def load_plugins
      super
      extension_loader.discover_extensions
    end

    def after_initialize
      extension_loader.activate_extensions
      super
    end

    def initialize_default_admin_tabs
      admin.tabs.clear
      admin.tabs.add "Pages",    "/admin/pages"
      admin.tabs.add "Snippets", "/admin/snippets"
      admin.tabs.add "Layouts",  "/admin/layouts", :visibility => [:admin, :developer]
    end

    def initialize_framework_views
      view_paths = returning [] do |arr|
        # Add the singular view path if it's not in the list
        arr << configuration.view_path if !configuration.view_paths.include?(configuration.view_path)
        # Add the default view paths
        arr.concat configuration.view_paths
        # Add the extension view paths
        arr.concat extension_loader.view_paths
        # Reverse the list so extensions come first
        arr.reverse!
      end
      ActionMailer::Base.view_paths = view_paths if configuration.frameworks.include?(:action_mailer) || defined?(ActionMailer::Base)
      ActionController::Base.view_paths = view_paths if configuration.frameworks.include?(:action_controller)
    end

    def initialize_routing
      extension_loader.add_controller_paths
      super
    end

    def admin
      configuration.admin
    end

    def extension_loader
      ExtensionLoader.instance {|l| l.initializer = self }
    end
  end

end
