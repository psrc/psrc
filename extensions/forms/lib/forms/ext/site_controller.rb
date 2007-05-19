module Forms
  module Ext
    module SiteController
      def self.included(site_controller)
        
        # InstanceMethods
        site_controller.class_eval do
          # Installs the current SiteController instance into Page in order
          # to allow many of the ActionView::Helpers to function correctly
          def process_page_with_forms_support(page)
            page.controller = self
            process_page_without_forms_support(page)
          end
          alias_method_chain :process_page, :forms_support
        end
        
      end
    end
  end
end