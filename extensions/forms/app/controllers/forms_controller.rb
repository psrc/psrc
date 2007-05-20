# TODO: Move into core, use in SiteController
module PageProcessing
  private
    def process_page(page)
      page.process(request, response)
    end

    # The following is modified to allow for not having/needing a cache
    def show_uncached_page(url, cache = nil)
      @page = find_page(url)
      unless @page.nil?
        process_page(@page)
        cache.cache_response(url, response) if cache && page.cache? && live?
        @performed_render = true
      else
        render :template => 'site/not_found', :status => 404
      end
    rescue Page::MissingRootPageError
      redirect_to welcome_url
    end
    
    def find_page(url)
      found = Page.find_by_url(url, live?)
      found if found and (found.published? or dev?)
    end
    
    def dev?
      if dev_host = @config['dev.host']
        request.host == dev_host
      else
        request.host =~ /^dev\./
      end
    end
    
    def live?
      not dev?
    end
end

class FormsController < ApplicationController
  include PageProcessing
  
  no_login_required
  
  def create
    form = Forms::Simple.new(params)
    form.save!
    show_uncached_page(form.page_url)
  end
end