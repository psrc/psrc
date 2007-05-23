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
    memento, attributes = *extract_form
    form = send("create_#{memento.form_type}", memento, attributes)
    Forms::Action.perform(request.method, form)
    show_uncached_page(memento.page_url)
  end
    
  private
    def create_meta(memento, attributes)
      meta_form = Forms::Meta::Form.find_by_name(memento.model_name)
      Forms::Form.create!(attributes)
    end
    
    def create_model(memento, attributes)
      # It should be an ActiveRecord (or at least implement create!)
      memento.model.create!(attributes[:parameters])
    end
  
    def create_transient(memento, attributes)
      Forms::Transient.new(memento, attributes)
    end
  
    def extract_form
      memento = Forms::Memento.new(params[:form_memento])
      form_parameters = params[memento.model_name.to_sym] || {}
      form_attributes = {
        :model_name => memento.model_name, :page_url => memento.page_url,
        :parameters => form_parameters
      }
      [memento, form_attributes]
    end
end