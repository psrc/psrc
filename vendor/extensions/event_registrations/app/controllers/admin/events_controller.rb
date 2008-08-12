class Admin::EventsController < ApplicationController
  def index
    @events = Event.find :all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new params[:event]
    if @event.save
      redirect_to admin_event_path(@event)
    else
      flash.now[:error] = "Event could not be created"
      render :action => 'new'
    end
  end

  def show
    @event = Event.find params[:id]
  end
end
