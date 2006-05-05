require_dependency 'admin/model_controller'
require_dependency 'page_cache'

class Admin::SnippetController < Admin::AbstractModelController
  model :snippet
  attr_accessor :page_cache
  
  def initialize
    super
    @page_cache = PageCache.instance
  end
  
  def save
    saved = super
    @page_cache.clear if saved
    saved
  end
end