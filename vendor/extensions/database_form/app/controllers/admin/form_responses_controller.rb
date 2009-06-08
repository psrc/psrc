require 'ostruct'
require 'csv'

class Admin::FormResponsesController < ApplicationController
  def index
    @filter = OpenStruct.new(:name => "", :start_time => 7.days.ago, :end_time => Time.now)
    @form_names = FormResponse.find_by_sql("SELECT DISTINCT name FROM form_responses ORDER BY name").map { |fr| fr.name }
  end

  def export
    options = { :order => "name, created_at" }
    if params[:filter]
      conditions = []
      conditions << "name = '#{params[:filter][:name]}'" if params[:filter][:name]
      conditions << "created_at >= '#{build_datetime_from_params(:start_time, params[:filter])}'" if params[:filter]['start_time(1i)']
      conditions << "created_at <= '#{build_datetime_from_params(:end_time, params[:filter])}'" if params[:filter]['end_time(1i)']
      options[:conditions] = conditions.join(" AND ")
    end
    @form_responses = FormResponse.find(:all, options)

    if params[:commit] == "Export as CSV"
      buf = ''
      return "No form responses detected" if @form_responses.blank?
      keys = @form_responses.last.content.keys.sort
      CSV.generate_row keys, keys.size, buf
      @form_responses.each do |response|
        arr = []
        keys.each { |k| arr << response.content[k] }
        CSV.generate_row arr, arr.size, buf
      end
      send_data buf, :type => "text/csv", :filename => "#{params[:filter][:name]}-form_responses.csv"
    end
    
  end

  def clear
    FormResponse.destroy_all ["name = ?", params[:name]]
    flash[:notice] = "Responses deleted!"
    redirect_to :action => :index
  end

  protected

  # Reconstruct a datetime object from datetime_select helper form params
  def build_datetime_from_params(field_name, params)
    DateTime.new(params["#{field_name.to_s}(1i)"].to_i,
             params["#{field_name.to_s}(2i)"].to_i,
             params["#{field_name.to_s}(3i)"].to_i,
             params["#{field_name.to_s}(41)"].to_i,
             params["#{field_name.to_s}(5i)"].to_i).strftime('%Y-%m-%d %H:%M')
  end
end
