class EventsController < ApplicationController
  layout 'event_registrations'
  no_login_required
  def show
    @event = Event.find params[:id]
  end

end
