class Admin::EventsController < ApplicationController
  def show
    @event = Event.find params[:id]
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new params[:event]
    if @event.save
      flash[:notice] = "Event saved"
      redirect_to admin_events_path
    else
      flash[:error] = "Couldn't save event"
      render :action => 'new'
    end
  end

  def update
    @event = Event.find params[:id]
    if @event.update_attributes params[:event]
      flash[:notice] = "Event updated"
      redirect_to admin_events_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.destroy params[:id]
    flash[:notice] = "Event deleted"
    redirect_to admin_events_path
  end

  def edit
    @event = Event.find params[:id]
  end

  def index
    @events = Event.find :all, :order => 'start_date'
  end
end
