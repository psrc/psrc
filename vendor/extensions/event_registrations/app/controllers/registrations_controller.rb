class RegistrationsController < ApplicationController
  layout 'event_registrations'
  
  def select_type
    @event = Event.find params[:id]
    @progress_step = 1
  end

  def whos_attending
    @event = Event.find params[:event_id]
    @event_option = @event.event_options.find params[:event_option_id]
    @progress_step = 2
  end

  def contact_info
    @event = Event.find params[:event_id]
    @event_option = @event.event_options.find params[:event_option_id]
    @progress_step = 3
  end
  
end
