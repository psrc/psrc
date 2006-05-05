require_dependency 'admin/model_controller'

class Admin::LayoutController < Admin::AbstractModelController
  model :layout
  
  attr_accessor :page_cache
  
  only_allow_access_to :index, :new, :edit, :remove,
    :when => [:developer, :admin],
    :denied_url => { :controller => 'page', :action => 'index' },
    :denied_message => 'You must have developer privileges to perform this action.'

  def initialize
    super
    @page_cache = PageCache.instance
  end
  
  def save
    saved = super
    model.pages.each { |page| @page_cache.expire(page.url) } if saved
    saved
  end
end