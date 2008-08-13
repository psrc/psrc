class RegistrationsController < ApplicationController
  layout 'event_registrations'

  def select_type
    @event = Event.find params[:id]
  end

  def whos_attending
    @event = Event.find params[:event_id]
    @event_option = @event.event_options.find params[:event_option_id]
  end

  def contact_info
  end

end
