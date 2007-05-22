class ExtensionsController < ApplicationController
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]
  around_filter :scope_to_current_author, :only => [:new, :edit, :create, :update, :destroy]
  around_filter :scope_to_author, :only => [:index, :show]
  # GET /extensions
  # GET /extensions.xml
  def index
    @extensions = Extension.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @extensions.to_xml }
      format.yaml { render :text => @extensions.to_yaml}
    end
  end

  # GET /extensions/1
  # GET /extensions/1.xml
  def show
    @extension = Extension.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @extension.to_xml }
      format.yaml { render :yaml => @extensions.to_yaml}
    end
  end

  # GET /extensions/new
  def new
    @extension = Extension.new
  end

  # GET /extensions/1;edit
  def edit
    @extension = Extension.find(params[:id])
  end

  # POST /extensions
  # POST /extensions.xml
  def create
    @extension = Extension.create(params[:extension])

    respond_to do |format|
      if @extension.valid?
        flash[:notice] = 'Extension was successfully created.'
        format.html { redirect_to extension_url(@extension) }
        format.xml  { head :created, :location => extension_url(@extension) }
        format.yaml { head :created, :location => extension_url(@extension) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @extension.errors.to_xml }
        format.yaml { render :yaml => @extension.errors.to_yaml}
      end
    end
  end

  # PUT /extensions/1
  # PUT /extensions/1.xml
  def update
    @extension = Extension.find(params[:id])

    respond_to do |format|
      if @extension.update_attributes(params[:extension])
        flash[:notice] = 'Extension was successfully updated.'
        format.html { redirect_to extension_url(@extension) }
        format.xml  { head :ok }
        format.yaml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @extension.errors.to_xml }
        format.yaml { render :yaml => @extension.errors.to_yaml}
      end
    end
  end

  # DELETE /extensions/1
  # DELETE /extensions/1.xml
  def destroy
    @extension = Extension.find(params[:id])
    @extension.destroy

    respond_to do |format|
      if @extension and @extension.destroy  
        format.html { redirect_to extensions_url }
        format.xml  { head :ok }
        format.yaml { head :ok }
      else
        format.html { flash[:error] = "Incorrect password."; redirect_to extensions_url }
        format.xml { render :nothing => true, :status => "409 Conflict"}
        format.yaml { render :nothing => true, :status => "409 Conflict"}
      end
    end
  end
  
  protected
    def scope_to_current_author
      Extension.with_scope :find => {:conditions => ["author_id = ?", current_author.id]}, :create => {:author_id => current_author.id} do
        yield
      end
    end
    
    def scope_to_author
      if params[:author_id]
        Extension.with_scope :find =>{:conditions => ['author_id = ?', params[:author_id]]} do
          yield
        end
      else
        yield
      end
    end
end
