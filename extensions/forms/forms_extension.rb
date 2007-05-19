require_dependency 'application'

class FormsExtension < Radiant::Extension
  version "1.0"
  description "Forms: A Form Generation Engine for Radiant"
  url "http://forms.os.thewilliams.ws"
  
  def activate    
    [Forms::Tags, Forms::Ext::Page].each { |ext| Page.send :include, ext }
    SiteController.send :include, Forms::Ext::SiteController
  end
  
  def deactivate
    SiteController.send :alias_method, :process_page, :process_page_without_forms_support
  end
  
end