class RegistrationsController < ApplicationController
  layout 'event_registrations'
  before_filter :get_event_and_option
  
  def options
    @event = Event.find params[:id]
    @progress_step = 1
  end

  def attendee_info
    @progress_step = 2
  end

  def contact_info
    @progress_step = 3
  end
  
  def payment
    @progress_step = 4    
  end
  
  def confirmation
    @progress_step = 5
  end

  private
  
  def get_event_and_option
    @event = Event.find params[:event_id] if params[:event_id]
    @event_option = @event.event_options.find params[:event_option_id] if params[:event_option_id]
  end
  
end
