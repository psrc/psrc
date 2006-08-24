require_dependency 'controllers/application'
require_dependency 'controllers/site_controller'

class SiteController

  include Behavior::View

  alias_method :show_and_cache_page, :show_uncached_page

  def show_uncached_page(url)
    Behavior::Base.set_controller(self)
    show_and_cache_page(url)
  end

end
