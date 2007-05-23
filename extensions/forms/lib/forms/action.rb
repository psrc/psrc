module Forms
  class Action
    include Simpleton
    include Annotatable

    annotate :action_name, :description
    
    class << self
      def inherited(subclass)
        subclass.action_name = subclass.name.to_name('Action')
      end
      
      def description_file(filename)
        text = File.read(filename) rescue ""
        self.description text
      end
      
      def perform(verb, form)
        descendants.each do |action|
          action.instance.perform(verb, form)
        end
      end
    end
    
    def perform(verb, form)
      send(verb, form) if respond_to?(verb)
    end
  end
end