class RegistrationsController < ApplicationController

  include SslRequirement
  ssl_required :payment_by_credit_card, :submit_payment_by_credit_card, :poll_for_credit_card_payment
  
  layout :load_layout

  no_login_required

  STEPS = { "attendee_info" => 1, "contact_info" => 2, "payment_type" => 3, 
            "payment_by_check" => 4, "payment_by_credit_card" => 4, "poll_for_credit_card_payment" => 4, "confirmation" => 5 }

  before_filter :redirect_to_correct_host
  before_filter :get_event_and_option
  before_filter :set_progress_step
  before_filter :check_for_started_registration,   :except => :attendee_info
  before_filter :check_for_completed_registration, :except => :confirmation

  def attendee_info
    remember_event_and_option
    @number_of_attendees = @event_option.max_number_of_attendees
    session[:registration] = Registration.new :event => @event
    @group = RegistrationGroup.new :event_option => @event_option
    1.upto(@event_option.max_number_of_attendees) do |a|
      @group.event_attendees.build
    end
  end

  def submit_attendee_info
    @group                = session[:registration].registration_groups.build :event_option => @event_option
    @number_of_attendees  = @event_option.max_number_of_attendees
    @group.group_name     = params[:group][:group_name] if params[:group]

    params[:person].each { |i, p| @group.event_attendees << EventAttendee.new(p) unless p[:name].blank?  }

    @group.registration   = session[:registration]

    if @group.valid?
      redirect_to_next_step
    else
      @group.event_attendees.size.upto(@number_of_attendees-1) do 
        @group.event_attendees.build
      end
      flash.now[:error] = "Please fix errors below (#{ @group.errors.full_messages.inspect })"
      render :action => :attendee_info
    end
  end

  def contact_info
    make_them_start_over and return false unless session[:registration]
    @registration_contact = session[:contact] || RegistrationContact.new(:state => "WA")
  end

  def submit_contact_info
    session[:contact] = @registration_contact = session[:registration].build_registration_contact(params[:registration_contact])
    if @registration_contact.valid?
      redirect_to_next_step
    else
      flash.now[:error] = "Please fix errors below"
      render :action => :contact_info
    end
  end

  def payment_type
    unless session[:registration].payment_required?
      session[:registration].save!
      redirect_to confirmation_path
    end
  end

  def submit_payment_type
    if params[:payment]
      if params[:payment][:type] =~ /credit/i
        redirect_to payment_by_credit_card_path
      else
        redirect_to payment_by_check_path
      end
    else
      flash[:error] = "Please select a payment method."
      render :action => 'payment_type'
    end
  end
  
  def payment_by_credit_card
    make_them_start_over and return false unless session[:registration]
    @registration = session[:registration]
    @card = session[:payment].card if session[:payment]
  end

  def submit_payment_by_credit_card
    @registration = session[:registration]
    @card = session[:payment].card if session[:payment]
    begin
      session[:payment] = PaymentByCreditCard.new(params[:card], session[:registration].payment_amount, session[:registration])
      redirect_to poll_for_credit_card_payment_path
    rescue RuntimeError => e
      flash.now[:error] = e
      @card = ActiveMerchant::Billing::CreditCard.new(params[:card])
      @card.valid?
      render :action => 'payment_by_credit_card'
    end
  end

  def payment_by_check
    make_them_start_over and return false unless session[:registration]
    @registration = session[:registration]
  end

  def submit_payment_by_check
    @payment = PaymentByCheck.new :agreement    => params[:payment][:agreement], :amount => session[:registration].payment_amount,
                                  :payment_date => convert_date(params[:payment], :payment_date)
    if @payment.valid?
      check = Payment.create_from_check @payment
      session[:registration].payment = check
      session[:registration].save!
      redirect_to confirmation_path
    else
      render :action => 'payment_by_check'
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
  
  def confirmation
    @registration = session[:registration]
    make_them_start_over if @registration.new_record?
    @registration_group = @registration.registration_groups.first
  end

  private
  
  def get_event_and_option
    @event = Event.find(params[:event_id] || session[:event_id])
    @event_option = @event.event_options.find(params[:event_option_id] || session[:event_option_id])
  end

  def redirect_to_next_step
    current_step = session[:current_registration_step]
    next_step = STEPS.index(current_step + 1)
    redirect_to :action => next_step
  end

  def set_progress_step
    if current_step = STEPS[self.action_name]
      @progress_step = session[:current_registration_step] = current_step
    end
    true
  end

  def convert_date(hash, date_symbol_or_string)
    attribute = date_symbol_or_string.to_s
    return Date.new(hash[attribute + '(1i)'].to_i, hash[attribute + '(2i)'].to_i, hash[attribute + '(3i)'].to_i)   
  end

  def check_for_completed_registration
    if session[:registration] and !session[:registration].new_record?
      session[:registration].destroy
      make_them_start_over
    end
  end

  def check_for_started_registration
    make_them_start_over and return false unless session[:registration]
  end

  def make_them_start_over
    flash[:notice] = "Please continue your registration process."
    redirect_to event_path(@event)
    return false
  end

  def remember_event_and_option
    session[:event_id] = @event.id
    session[:event_option_id] = @event_option.id
  end

  def redirect_to_correct_host
    return true unless RAILS_ENV == 'production'
    if request.host != "secure.psrc.org"
      redirect_to request.protocol + "secure.psrc.org" + request.request_uri
      flash.keep
      return false
    end
  end

  def load_layout
    @event.layout
  end
end
