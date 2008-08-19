class RegistrationsController < ApplicationController
  layout 'event_registrations'
  no_login_required

  STEPS = %w{ placeholder attendee_info contact_info payment_type payment confirmation }

  before_filter :get_event_and_option
  before_filter :set_progress_step
  
  def attendee_info
    @number_of_attendees = @event_option.max_number_of_attendees
    @set = AttendeeSet.new @number_of_attendees
    if request.post?
      table_name = params[:set][:table_name] if params[:set]
      @set.update params[:person], table_name
      if @set.valid?
        redirect_to_next_step
        session[:registration_set] = @set
      end
    end
  end

  def contact_info
    if request.post?
      @set = session[:setregistration_set]
      @registration_contact = RegistrationContact.new params[:registration_contact]
      if @registration_contact.valid?
        redirect_to_next_step
        session[:registration_contact] = @registration_contact
      end
    end
  end

  def payment_type
  end
  
  def payment
  end
  
  def processing
    @progress_step = 4
  end
  
  def confirmation
  end

  private
  
  def get_event_and_option
    @event = Event.find params[:event_id] if params[:event_id]
    @event_option = @event.event_options.find params[:event_option_id] if params[:event_option_id]
  end

  def redirect_to_next_step
    redirect_to :action => STEPS[@progress_step + 1] 
  end

  def set_progress_step
    @progress_step = STEPS.index(self.action_name) 
  end
  
end
