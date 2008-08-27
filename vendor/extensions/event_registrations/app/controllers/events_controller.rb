class EventsController < ApplicationController
  no_login_required
  def show
    @event = Event.find params[:id]
    @progress_step = 1
    session[:registration] = nil
  end

end
