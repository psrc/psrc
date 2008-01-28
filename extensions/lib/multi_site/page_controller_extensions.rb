module MultiSite::PageControllerExtensions
  def self.included(base)
    base.class_eval {
      alias_method_chain :index, :root
      alias_method_chain :clear_model_cache, :site
      %w{remove clear_cache}.each do |m|
        alias_method_chain m.to_sym, :back
      end
    }
  end
  
  def index_with_root
    cookies.delete('expanded_rows')
    if params[:root] # If a root page is specified
      @homepage = Page.find(params[:root])
      @site = @homepage.root.site
    elsif @site = Site.find(:first, :order => "position ASC") # If there is a site defined
      if @site.homepage
        @homepage = @site.homepage
      else
        index_without_root
      end
    else # Just do the default
      index_without_root
    end
  end
    
  def remove_with_back
    @page = Page.find(params[:id])
    if request.post?
      announce_pages_removed(@page.children.count + 1)
      @page.destroy
      return_url = session[:came_from]
      session[:came_from] = nil
      if return_url && return_url != page_index_url(:root => @page)
        redirect_to return_url
      else
        redirect_to page_index_url(:page => @page.parent)
      end
    else
      session[:came_from] = request.env["HTTP_REFERER"]
    end
  end

  def clear_cache_with_back
    if request.post?
      @cache.clear
      announce_cache_cleared
      redirect_to :back
    else
      render :text => 'Do not access this URL directly.'
    end
  end
  
  def clear_model_cache_with_site
    Page.current_site ||= @site || @page.root.site
    clear_model_cache_without_site
  end
end