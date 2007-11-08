# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class ShareLayoutsExtension < Radiant::Extension
  version "0.2"
  description "Allows Radiant layouts to be used as layouts for standard Rails actions."
  url "http://wiki.radiantcms.org/Thirdparty_Extensions"

  def activate
    ActionController::Base.send :include, ShareLayouts::RadiantLayouts
    ApplicationController.send :helper, ShareLayouts::Helper
  end
  
  def deactivate
  end
  
end
