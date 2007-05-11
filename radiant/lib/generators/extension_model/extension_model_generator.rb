require 'rails_generator/base'
require 'rails_generator/generators/components/model/model_generator'

class ExtensionModelGenerator < ModelGenerator
  
  attr_accessor :extension_name
  
  def initialize(runtime_args, runtime_options = {})
    runtime_args = runtime_args.dup
    @extension_name = runtime_args.shift
    super(runtime_args, runtime_options)
  end
  
  def banner
    "Usage: #{$0} extension_model ExtensionName ModelName [field:type, field:type]"
  end
  
  def extension_path
    File.join('vendor', 'extensions', @extension_name.underscore)
  end
  
  def destination_root
    File.join(RAILS_ROOT, extension_path)
  end
  
end