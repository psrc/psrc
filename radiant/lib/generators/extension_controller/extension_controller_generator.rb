require 'rails_generator/base'
require 'rails_generator/generators/components/controller/controller_generator'

class ExtensionControllerGenerator < ControllerGenerator
  
  attr_accessor :extension_name
  
  def initialize(runtime_args, runtime_options = {})
    runtime_args = runtime_args.dup
    @extension_name = runtime_args.shift
    super(runtime_args, runtime_options)
  end
  
  def banner
    "Usage: #{$0} #{spec.name} ExtensionName #{spec.name.camelize}Name [options]"
  end
  
  def extension_path
    File.join('vendor', 'extensions', @extension_name.underscore)
  end
  
  def destination_root
    File.join(RAILS_ROOT, extension_path)
  end
  
end