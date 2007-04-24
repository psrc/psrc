require_dependency 'radiant'

ActionView::Base.field_error_proc = Proc.new do |html, instance|
  %{<div class="error-with-field">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}
end

class ApplicationController < ActionController::Base
  include LoginSystem
  
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
  
  private
  
    def set_current_user
      UserActionObserver.current_user = session['user']
    end
  
    def set_javascripts_and_stylesheets
      @stylesheets = ['admin/main']
      @javascripts = ['prototype', 'string', 'effects', 'dragdrop', 'controls', 'tabcontrol', 'ruledtable']
    end
end