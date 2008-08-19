class RegistrationsController < ApplicationController
  layout 'event_registrations'
  no_login_required

  STEPS = %w{ placeholder attendee_info contact_info payment_type payment_by_credit_card confirmation }

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
    if request.post?
      if params[:payment][:type] =~ /credit/i
        redirect_to payment_by_credit_card_path
      else
        redirect_to payment_by_check_path
      end
    end
  end
  
  def payment_by_credit_card
    if request.post?
      begin
        session[:payment] = Payment.new(params[:card], @event_option.price)
      rescue RuntimeError => e
        flash[:error] = e
        @card = ActiveMerchant::Billing::CreditCard.new(params[:card])
        @card.valid?
        return
      end
      redirect_to poll_for_credit_card_payment_path
    end
  end

  def payment_by_check
  end

  def poll_for_credit_card_payment
    if session[:payment].completed?
      redirect_to confirmation_path
    elsif session[:payment].error?
      redirect_to payment_by_credit_card_path
    else
      redirect_to poll_for_credit_card_payment_path
    end
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
