require 'ostruct'

module Forms  
  class Transient < OpenStruct
    def initialize(memento, attributes)
      super(attributes)
      self.model_name = memento.model_name
      self.page_url = memento.page_url
    end
  end
end