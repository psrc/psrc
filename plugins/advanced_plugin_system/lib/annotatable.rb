module Annotatable
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def annotate(*attrs)
      attrs.each do |attr| 
        class_eval %{
          def self.#{attr}(string = nil)
            self.class_eval { @#{attr} = string || @#{attr} }
          end
          def self.#{attr}=(string = nil)
            #{attr}(string)
          end
        }
      end
    end    
  end
end