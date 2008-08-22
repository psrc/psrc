class Admin::TemplatesController < ApplicationController
  def index
  end
  
  def two_col_with_nav
    render :layout => "template"
  end
  
  def three_col_with_nav
    render :layout => "template"
  end

end
