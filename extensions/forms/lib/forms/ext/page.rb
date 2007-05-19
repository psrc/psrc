module Forms
  module Ext
    module Page
      def self.included(page)
        
        # InstanceMethods
        page.class_eval do
          # Adds a controller attribute to Page so that ActionView::Helpers can be used.
          attr_accessor :controller
        end
        
      end
    end
  end
end