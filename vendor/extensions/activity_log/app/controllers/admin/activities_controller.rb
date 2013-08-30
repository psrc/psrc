require 'fastercsv'
class Admin::ActivitiesController < ApplicationController

  def index
    conditions = params[:subject_type] ? { :subject_type => subject_type } : {}
    activities = Activity.find :all, :order => 'activities.occurred_at asc', :conditions => conditions
    respond_to do |format|
      format.csv do
        csv_string = FasterCSV.generate do |csv|
          csv << ['id', 'type', 'title', 'action', 'user', 'date']
          activities.each do |activity|
            csv << [activity.subject_attribute(:id), activity.subject_type, activity.subject_attribute(:title), activity.action, activity.user_attribute(:name), activity.occurred_at]
          end
        end
        send_data csv_string, :filename => "#{ subject_type.downcase }_activity_#{ Time.now.strftime('%a_%b_%d_%Y').downcase }.csv"
      end
    end
  end

  private

    def subject_type
      @subject_type ||= {
        'Asset' => 'Asset',
        'Page' => 'Page',
        nil => 'All'
      }[params[:subject_type]]
    end
end
