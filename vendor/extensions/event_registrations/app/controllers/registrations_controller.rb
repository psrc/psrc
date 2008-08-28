class RegistrationsController < ApplicationController
  no_login_required

  STEPS = { "attendee_info" => 1, "contact_info" => 2, "payment_type" => 3, 
            "payment_by_check" => 4, "payment_by_credit_card" => 4, "poll_for_credit_card_payment" => 4, "confirmation" => 5 }

  before_filter :get_event_and_option
  before_filter :set_progress_step
  before_filter :check_for_completed_registration, :except => :confirmation

  def attendee_info
    @number_of_attendees = @event_option.max_number_of_attendees
    @set = AttendeeSet.new @number_of_attendees
    if request.post?
      table_name = params[:set][:table_name] if params[:set]
      @set.update params[:person], table_name
      if @set.valid?
        redirect_to_next_step
        session[:registration_set] = @set
      else
        flash.now[:error] = "Please fix errors below"
      end
    end
  end

  def contact_info
    make_them_start_over and return false unless session[:registration_set]
    @registration_contact = session[:registration_contact]
    if request.post?
      @set = session[:registration_set]
      @registration_contact = RegistrationContact.new params[:registration_contact]
      if @registration_contact.valid?
        redirect_to_next_step
        session[:registration_contact] = @registration_contact
      else
        flash.now[:error] = "Please fix errors below"
      end
    end
  end

  def payment_type
    make_them_start_over and return false unless session[:registration_contact]
    if request.post?
      if  params[:payment]
        if params[:payment][:type] =~ /credit/i
          redirect_to payment_by_credit_card_path
        else
          redirect_to payment_by_check_path
        end
      else
        flash[:error] = "Please select a payment method."
      end
    end
  end
  
  def payment_by_credit_card
    make_them_start_over and return false unless session[:registration_contact]
    @card = session[:payment].card if session[:payment]
    if request.post?
      begin
        session[:payment] = PaymentByCreditCard.new(params[:card], @event_option.price, build_registration_object)
      rescue RuntimeError => e
        flash.now[:error] = e
        @card = ActiveMerchant::Billing::CreditCard.new(params[:card])
        @card.valid?
        return
      end
      redirect_to poll_for_credit_card_payment_path
    end
  end

  def payment_by_check
    make_them_start_over and return false unless session[:registration_contact]
    if request.post?
      @payment = PaymentByCheck.new :agreement    => params[:payment][:agreement], 
                                    :payment_date => convert_date(params[:payment], :payment_date)
      if @payment.valid?
        reg = build_registration_object
        reg.payment = @payment
        reg.save!
        session[:registration] = reg
        redirect_to confirmation_path
      end
    end
  end

  def poll_for_credit_card_payment
    make_them_start_over and return false unless session[:payment]
    if session[:payment].completed?
      session[:registration] = session[:payment].registration
      redirect_to confirmation_path
    elsif session[:payment].error?
      flash[:error] = session[:payment].error_message
      redirect_to payment_by_credit_card_path
    end
  end
  
  def processing
    @progress_step = 4
  end
  
  def confirmation
    @registration = session[:registration]
  end

  private
  
  def get_event_and_option
    @event = Event.find params[:event_id] if params[:event_id]
    @event_option = @event.event_options.find params[:event_option_id] if params[:event_option_id]
  end

  def redirect_to_next_step
    current_step = STEPS[self.action_name].to_i
    next_step = STEPS.index(current_step + 1)
    redirect_to :action => next_step
  end

  def set_progress_step
    @progress_step = STEPS[self.action_name]
  end

  def build_registration_object
    Registration.new :registration_set      => session[:registration_set], 
                     :registration_contact  => session[:registration_contact],
                     :event_option          => @event_option
  end

  def convert_date(hash, date_symbol_or_string)
    attribute = date_symbol_or_string.to_s
    return Date.new(hash[attribute + '(1i)'].to_i, hash[attribute + '(2i)'].to_i, hash[attribute + '(3i)'].to_i)   
  end

  def check_for_completed_registration
    make_them_start_over if session[:registration] and !session[:registration].new_record?
  end

  def check_for_started_registraiton
    make_them_start_over if !session[:registration]
  end

  def make_them_start_over
    flash[:notice] = "Please continue your registration process."
    redirect_to event_path(@event)
    return false
  end

end
