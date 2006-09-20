module TemplatePathsExtension
  def self.included(base)
    base.class_eval %{
      cattr_accessor :template_paths
      self.template_paths = [ActionController::Base.template_root].compact
      alias :full_template_path_without_paths :full_template_path
      alias :full_template_path :full_template_path_with_paths 
    }
  end
  
  def full_template_path_with_paths (template_path, extension)
    template_paths.each do |path|
      full_path = File.join(path, "#{template_path}.#{extension}")
      return full_path if File.exists?(full_path)
    end
    full_template_path_without_paths(template_path, extension)
  end
end

ActionView::Base.class_eval { include TemplatePathsExtension }