require_dependency 'page_cache'

class SiteController < ApplicationController
  session :off
  
  no_login_required
  
  attr_accessor :config, :page_cache
  
  def initialize
    @config = Radiant::Config
    @page_cache = PageCache.instance
  end

  def show_page
    url = params[:url].to_s
    if live? and (content = @page_cache[url])
      render :text => content
    else
      @page = find_page(url)
      unless @page.nil?
        @page.process(request, response)
        @page_cache[url] = response.body if live? and @page.cache?
        @performed_render = true
      else
        render :template => 'site/not_found', :status => 404
      end
    end
  end
  
  private
    
    def find_page(url)
      found = Page.find_by_url(url)
      found if found and (found.published? or dev?)
    end

    def dev?
      (@request.host == @config['dev.host']) or (@request.host =~ /^dev/)
    end
    
    def live?
      not dev?
    end

end