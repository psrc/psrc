module Forms
  
  class Form < ActiveRecord::Base
    serialize :parameters
    
    # Delegate to serialized parameters, if possible
    def method_missing(method, *args)
      params = read_attribute(:parameters)
      if params && params[method]
        params[method]
      else
        super
      end
    end
  end
  
end