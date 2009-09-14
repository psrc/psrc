class EventsController < ApplicationController
  no_login_required
  include SslRequirement
  layout :load_layout

  def show
    redirect_to "https://secure.psrc.org/event/#{params[:id]}" and return unless params[:stay_here]
    @event = Event.find params[:id]
    @progress_step = 1
    session[:registration] = nil
  end

  protected

  def ssl_required?
    true
  end

  def load_layout
    @event.layout
  end

end
