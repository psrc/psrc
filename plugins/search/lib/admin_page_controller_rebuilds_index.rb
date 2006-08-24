require_dependency 'controllers/application'
require_dependency 'controllers/admin/page_controller'

class Admin::PageController

  include Behavior::View

  alias_method :clear_cache_and_rebuild_index, :clear_cache

  def clear_cache
    Behavior::Base.set_controller(self)
    Page.rebuild_index if request.post?
    clear_cache_and_rebuild_index
  end

end
