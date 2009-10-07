require_dependency 'radiant'

class ApplicationController < ActionController::Base
  include HoptoadNotifier::Catcher
  include LoginSystem
  before_filter :do_old_redirects
  
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_current_user
  before_filter :set_javascripts_and_stylesheets
  
  attr_accessor :config
  
  def initialize
    super
    @config = Radiant::Config
  end
  
  # helpers to include additional assets from actions or views
  helper_method :include_stylesheet, :include_javascript
  
  def include_stylesheet(sheet)
    @stylesheets << sheet
  end
  
  def include_javascript(script)
    @javascripts << script
  end
  
  #def rescue_action_in_public(exception)
    #case exception
      #when ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction, ActionController::RoutingError
        #render :template => "site/not_found", :status => 404
      #else
        #super
    #end
  #end

  def do_old_redirects
    redirects = {
      "/projects/its/ritsip-docs.htm" =>  "/transportation/its/ritsip-docs",
      "/recovery.htm" =>  "/funding/arra/",
      "/projects/tip/" =>  "/transportation/tip/",
      "/projects/tip/currenttip/index.htm" =>  "/transportation/tip/current",
      "/projects/tip/selection/index.htm" =>  "/transportation/tip/selection/",
      "/publications/pubs/trends/index.htm" =>  "/data/trends/",
      "/projects/trans2040" =>  "/transportation/t2040/",
      "/projects/vision/index.htm" =>  "/growth/vision2040/",
      "/publications/pubs/view/viewmain.htm" =>  "/about/news/",
      "/publications/pubs/view/" =>  "/about/news/",
      "/data/index.htm" =>  "/data/",
      "/boards/" =>  "/about/boards/",
      "/boards/advisory/" =>  "/about/advisory/",
      "/about/members.htm" =>  "/about/members/",
      "/about/who/index.htm" =>  "/about/contact/staff-roster/",
      "/speakers/bob_drewel_bio.htm" =>  "/about/public/bobbio/",
      "/about/titlevi/index.htm" =>  "/about/public/titlevi/",
      "/publications/index.htm" =>  "/about/pubs/",
      "/about/rfps/index.htm" =>  "/about/rfp/",
      "/links.htm" =>  "/about/infocenter/useful-links/",
      "/about/jobs/index.htm" =>  "/about/careers/",
      "/boards/execbd/" =>  "/about/boards/exec",
      "/boards/operations/" =>  "/about/boards/ops",
      "/boards/tpb/" =>  "/about/boards/tpb",
      "/boards/gmpb/" =>  "/about/boards/gmpb",
      "/boards/cpsedd/index.htm" =>  "/about/boards/edd",
      "/boards/advisory/rtoc.htm" =>  "/about/advisory/rtoc",
      "/index.htm" => "/",
      "/projects/tip/index.htm" => "/transportation/tip",
      "/projects/tip/application/index.htm" => "/transportation/tip/applications/",
      "/projects/tip/applications/index.htm" => "/transportation/tip/applications/",
      "/projects/tip/applications/reference.htm" => "/transportation/tip/applications/tipreference",
      "/projects/tip/application/reference.htm" => "/transportation/tip/applications/tipreference",
      "/projects/tip/applications/tipinfo3.pdf" => "/assets/461/TIPINFO3.pdf",
      "/projects/tip/applications/tipinfo9.pdf" => "/assets/467/TIPINFO9.pdf",
      "/projects/tip/applications/SecuredUnsecured.pdf" => "/assets/469/SecuredUnsecured.pdf",
      "/projects/tip/currentTIP/index.htm" => "/transportation/tip/current"
    }

    if new_page = redirects[request.request_uri] or new_page = redirects[request.request_uri + "/"]
      redirect_to new_page and return false
    end
  end
  
  private
  
    def set_current_user
      UserActionObserver.current_user = current_user
    end
  
    def set_javascripts_and_stylesheets
      @stylesheets = %w(admin/main)
      @javascripts = %w(prototype string effects admin/tabcontrol admin/ruledtable admin/admin)
    end
end
