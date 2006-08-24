module ActionView
  class Base
    private

      alias_method :default_template_path, :full_template_path

      def full_template_path(template_path, extension)

        # check existance of template in normal application directory
        default_path = default_template_path(template_path, extension)
        return default_path if File.exist?(default_path)

        # check plugins to see if the template can be found in lib/views.
        Dir["#{RADIANT_ROOT}/vendor/plugins/*_behavior"].each do |plugin|
          plugin_path = File.join(plugin, 'lib', 'views',  template_path.to_s + '.' + extension.to_s)
          return plugin_path if File.exist?(plugin_path)
        end

        return default_path
      end
  end
end
