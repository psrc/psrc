class Admin::DashboardController < ApplicationController

  def index
    recent_range = 60.days.ago
    recent_conditions = {
      :conditions => ["updated_at > :updated_at", {:updated_at => recent_range}], 
      :limit =>100, 
      :order => 'updated_at DESC'}
    @updated_pages = Page.find(:all, recent_conditions)
    @updated_snippets = Snippet.find(:all, recent_conditions)
    @draft_pages = Page.find(:all, :conditions => {:status_id => Status['Draft'].id}, :limit => 100)
    @reviewed_pages = Page.find(:all, 
      :conditions => ["status_id = :status_id and updated_at > :updated_at",
        {:status_id => Status['Reviewed'].id, :updated_at => recent_range}], :limit => 100)
    @updated_layouts = Layout.find(:all, recent_conditions)
    @updated_assets = Asset.find(:all, recent_conditions)
    @asset_activities = Activity.find(:all, recent_conditions.merge(:conditions => [
      "updated_at > :updated_at AND subject_type = :subject_type",
      {:updated_at => recent_range, :subject_type => 'Asset'}
    ]))
  end
end
