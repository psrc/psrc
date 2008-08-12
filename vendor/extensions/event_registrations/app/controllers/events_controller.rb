class EventsController < ApplicationController
  layout 'event_registrations'
  def show
    @event = Event.find params[:id]
  end

  def index
  end
end
