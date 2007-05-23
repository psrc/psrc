module Forms
  class Memento
    attr_reader :form_type, :page_url
    
    def initialize(memento)
      raise InvalidMementoError.new(memento) unless match = memento =~ /^(\w*?):(([a-z_\/]+?):)?(.*)$/
      @form_type, @model, @page_url = $1, $3, $4
      @form_type = "transient" if @form_type.blank?
    end
    
    def model_name
      @model.split("/").last
    end
    
    def model
      # If they don't specify an action on the HTML form to have the thing
      # post to a custom controller, we're cool with that, but the model_name
      # had better be classify.constantize'able
      @model.classify.constantize
    end
  end
end