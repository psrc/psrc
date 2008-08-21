class Admin::EventOptionsController < ApplicationController
  def show
    @event_option = EventOption.find params[:id]
  end

  def destroy
    @event_option = EventOption.destroy params[:id]
    flash[:notice] = "Option deleted"
    redirect_to admin_events_path
  end

  def new
    @event_option = EventOption.new :event_id => params[:event_id]
    @event = @event_option.event
  end

  def create
    @event_option = EventOption.new params[:event_option]
    @event = @event_option.event
    if @event_option.save
      flash[:notice] = "Registration option created"
      redirect_to admin_events_path
    else
      flash[:error] = "Couldn't save option"
      render :action => 'new'
    end
  end

  def update
    @event_option = EventOption.find params[:id]
    if @event_option.update_attributes params[:event_option]
      flash[:notice] = "Option updated"
      redirect_to admin_events_path
    else
      render :action => 'edit'
    end
  end

  def edit
    @event_option = EventOption.find params[:id]
    @event = @event_option.event
  end

end
