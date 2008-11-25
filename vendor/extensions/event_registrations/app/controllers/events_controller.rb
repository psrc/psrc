class EventsController < ApplicationController
  no_login_required
  layout :load_layout

  def show
    @event = Event.find params[:id]
    @progress_step = 1
    session[:registration] = nil
  end

  protected

  def load_layout
    @event.layout
  end

end
