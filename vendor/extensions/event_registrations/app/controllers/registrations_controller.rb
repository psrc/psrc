class RegistrationsController < ApplicationController
  layout 'event_registrations'
  no_login_required

  STEPS = %w{ options attendee_info contact_info payment confirmation }

  before_filter :get_event_and_option
  before_filter :set_progress_step
  
  def options
    @event = Event.find params[:id]
  end

  def attendee_info
    @number_of_attendees = @event_option.max_number_of_attendees
    @set = AttendeeSet.new @number_of_attendees
    if request.post?
      @set.fill params[:person]
      if @set.valid?
        redirect_to_next_step
        session[:registration_set] = @set
      else
        flash.now[:error] = @set.errors.inspect
      end
    end
  end

  def contact_info
  end
  
  def payment
  end
  
  def confirmation
  end

  private
  
  def get_event_and_option
    @event = Event.find params[:event_id] if params[:event_id]
    @event_option = @event.event_options.find params[:event_option_id] if params[:event_option_id]
  end

  def redirect_to_next_step
    redirect_to :action => STEPS[STEPS.index(self.action_name)+1]
  end

  def set_progress_step
    @progress_step = STEPS.find { self.action_name }
  end
  
end
