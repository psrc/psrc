module Validatable
  class ValidatesAcceptanceOf < ValidationBase #:nodoc:
    def valid?(instance)
      instance.send(self.attribute) == "true" || instance.send(self.attribute) == "1"
    end
    
    def message(instance)
      super || "must be accepted"
    end
  end
end
