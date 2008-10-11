class PublisherController < ApplicationController
  def new
  end

  def create
    Publisher.publish!
    flash[:notice] = "Site is now being published"
    redirect_to '/admin/pages'
  end
end
