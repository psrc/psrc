require_dependency 'radiant'

ActionView::Base.field_error_proc = Proc.new do |html, instance|
  %{<div class="error-with-field">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}
end

class ApplicationController < ActionController::Base
  include LoginSystem
  
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_current_user
  before_filter :set_javascripts_and_stylesheets
  
  attr_accessor :config
  
  def initialize
    super
    @config = Radiant::Config
  end
  
  helper_method :include_stylesheet, :include_javascript
  def include_stylesheet(sheet)
    @stylesheets << sheet
  end
  
  def include_javascript(script)
    @javascripts << script
  end
  
  def rescue_action_in_public(exception)
    case exception
      when ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction, ActionController::RoutingError
        render :template => "site/not_found", :status => 404
      else
        super
    end
  end
  private
  
    def set_current_user
      UserActionObserver.current_user = current_user
    end
  
    def set_javascripts_and_stylesheets
      @stylesheets = ['admin/main']
      @javascripts = ['prototype', 'string', 'effects', 'dragdrop', 'controls', 'tabcontrol', 'ruledtable']
    end
end
