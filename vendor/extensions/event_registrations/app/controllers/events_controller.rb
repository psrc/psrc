class EventsController < ApplicationController
  layout 'event_registrations'
  no_login_required
  def show
    @event = Event.find params[:id]
    @progress_step = 1
    @hide_step_nav = true
  end

end
