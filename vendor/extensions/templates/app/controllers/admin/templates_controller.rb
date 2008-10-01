class Admin::TemplatesController < ApplicationController
  def index
    render :layout => "application"
  end

  def content
  end

  def front
    render :layout => "front", :action => "content"
  end
  
  def one_col
    render :layout => "one_col", :action => "content"
  end

  def one_col_with_nav
    render :layout => "one_col_with_nav", :action => "content"
  end
  
  def two_col_halves
    @hide_sub_content = true
    render :layout => "two_col_halves", :action => "content"
  end

  def two_col_two_thirds
    render :layout => "two_col_two_thirds", :action => "content"
  end

  def two_col_three_fourths
    render :layout => "two_col_three_fourths", :action => "content"  
  end

  def two_col_with_nav
    render :layout => "two_col_with_nav", :action => "content"
  end
  
  def three_col_thirds
    @hide_sub_content = true
    render :layout => "three_col_thirds", :action => "content"  
  end

  def three_col_with_nav
    @hide_sub_content = true
    render :layout => "three_col_with_nav", :action => "content"
  end

end
