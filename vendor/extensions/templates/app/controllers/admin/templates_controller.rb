class Admin::TemplatesController < ApplicationController
  layout "template"

  def index
    render :layout => "application"
  end

  def template
  end
  
  def two_col_with_nav
    @sidebar = true
    @title = "Two-Columns (180px Navigation, 1/2, 1/2)"
    @grid = :halves
    render :action => "template"
  end

  def two_col_halves
    @title = "Two Col (1/2, 1/2)"
    @grid = :halves
    render :action => "template"
  end

  def two_col_two_thirds
    @title = "Two Col (2/3, 1/3)"
    @grid = :two_thirds
    render :action => "template"
  end

  def two_col_three_fourths
    @title = "Two Col (3/4, 1/4)"
    @grid = :three_fourths
    render :action => "template"
  end
  
  def three_col_with_nav
    render :layout => "template"
  end

  def three_col_with_nav
    @sidebar = true
    @title = "Three-Columns (180px Navigation, 1/3, 1/3, 1/3)"
    @grid = :thirds
    render :action => "template"
  end

  def three_col_thirds
    @title = "Three-Columns (1/3, 1/3, 1/3)"
    @grid = :thirds
    render :action => "template"
  end
end
