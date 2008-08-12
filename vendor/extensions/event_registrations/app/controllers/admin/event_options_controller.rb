class Admin::EventOptionsController < ApplicationController
  def show
    @event_option = EventOption.find params[:id]
  end

  def new
    @event_option = EventOption.new :event_id => params[:event_id]
    @event = @event_option.event
  end

  def create
    @event_option = EventOption.new params[:event_option]
    if @event_option.save
      flash[:notice] = "EventOption saved"
      redirect_to admin_event_path(@event_option.event)
    else
      flash[:error] = "Couldn't save event"
      render :action => 'new'
    end
  end

  def update
    @event_option = EventOption.find params[:id]
    if @event_option.update_attributes params[:event_option]
      redirect_to admin_event_path(@event_option.event)
    else
      render :action => 'edit'
    end
  end

  def edit
    @event_option = EventOption.find params[:id]
    @event = @event_option.event
  end

  def index
    @event_options = EventOption.find :all, :order => 'start_date'
  end

end
