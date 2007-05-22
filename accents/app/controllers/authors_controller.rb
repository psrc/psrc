class AuthorsController < ApplicationController
  before_filter :login_required, :only => [:edit, :update]
  
  def index
    @authors = Author.find(:all)
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @authors.to_xml }
      format.yaml { render :yaml => @authors.to_yaml}
    end
  end
  
  def show
    @author = Author.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @author.to_xml }
      format.yaml { render :yaml => @author.to_yaml}
    end    
  end
  
  def edit
    @author = current_author
  end

  def update
    @author = current_author
    respond_to do |format|
      if @author.update_attributes(params[:author])
        format.html { redirect_to author_url(@author) }
        format.xml { head :ok }
        format.yaml { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml { render :xml => @author.errors.to_xml, :status => "409 Conflict"}
        format.yaml { render :yaml => @author.errors.to_yaml, :status => "409 Conflict"}
      end
    end
  end
  
  # render new.rhtml
  def new
  end

  def create
    @author = Author.new(params[:author])
    @author.save!
    self.current_author = @author
    redirect_back_or_default(profile_url)
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

end
