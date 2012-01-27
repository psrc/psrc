class RegistrationsController < ApplicationController

  include SslRequirement
  
  layout :load_layout

  no_login_required

  before_filter :redirect_to_correct_host
  before_filter :get_event_and_option
  before_filter :check_for_open_event
  before_filter :set_progress_step
  before_filter :check_for_started_registration,   :except => :attendee_info
  before_filter :check_for_completed_registration, :except => :confirmation

  def attendee_info
    remember_event_and_option
    session[:current_registration_step] = 1
    @number_of_attendees = @event_option.max_number_of_attendees
    session[:registration] = Registration.new :event => @event
    @group = RegistrationGroup.new :event_option => @event_option
    1.upto(@event_option.max_number_of_attendees) do |a|
      @group.event_attendees.build
    end

    if @event.attendee_same_as_contact?
      redirect_to :action => 'contact_info'
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
    remember_event_and_option
    session[:registration] ||= Registration.new :event => @event
    make_them_start_over and return false unless session[:registration]
    @registration_contact = session[:contact] || RegistrationContact.new(:state => "WA")
  end

  def submit_contact_info
    make_them_start_over and return false unless session[:registration]
    session[:contact] = @registration_contact = session[:registration].build_registration_contact(params[:registration_contact])
    if session[:registration].registration_groups.blank?
      group = session[:registration].registration_groups.build :event_option => @event_option, :registration => session[:registration]
      group.event_attendees.build :name => @registration_contact.name, :email => @registration_contact.email
    end

    if @registration_contact.valid?
      redirect_to_next_step
    else
      flash.now[:error] = "Please fix errors below"
      render :action => :contact_info
    end
  end

  def menu
    @menu_choices = @event_option.menu_choices
  end

  def submit_menu
    group = session[:registration].registration_groups.first
    group.event_attendees.first.menu_choice = MenuChoice.find params[:menu_choices]
    redirect_to_next_step
  end

  def payment_type
    make_them_start_over and return false unless session[:registration]
    unless session[:registration].payment_required?
      session[:registration].save!
      redirect_to confirmation_path
    end
  end

  def submit_payment_type
    make_them_start_over and return false unless session[:registration]
    if params[:payment]
      if params[:payment][:type] =~ /credit/i
        redirect_to payment_by_elavon_path
      else
        redirect_to payment_by_check_path
      end
    else
      flash[:error] = "Please select a payment method."
      render :action => 'payment_type'
    end
  end
  
  def payment_by_elavon
    make_them_start_over and return false unless session[:registration]
    @registration = session[:registration]
  end
  
  def submit_payment_by_elavon
    make_them_start_over and return false unless session[:registration] && params[:ssl_result] == '0'
    @registration = session[:registration]
    
    # Note: could save params[:ssl_txn_id] to identify payment for transaction
    # Payment#remote_payment_id is an integer, and does not seem to be in use
    
    @payment = Payment.create!({
      :amount => params[:ssl_amount],
      :payment_method => "Credit Card",
      :last_digits => params[:ssl_card_number][/(\d{4})$/]
    })
    
    @registration.payment = @payment
    @registration.save!
    
    redirect_to confirmation_path
  end
  
  def payment_by_credit_card
    make_them_start_over and return false unless session[:registration]
    @registration = session[:registration]
    @card = session[:payment].card if session[:payment]
  end

  def submit_payment_by_credit_card
    make_them_start_over and return false unless session[:registration]
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
    make_them_start_over and return false unless session[:registration]
    @registration = session[:registration]
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
    make_them_start_over and return false unless session[:registration]
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
    if !session[:registration] or !session[:registration].valid?
      make_them_start_over 
      return false 
    end
    if ! session[:registration].payment_required?
      session[:registration].save!
    end
    @registration = session[:registration]
    make_them_start_over if @registration.new_record?
    @registration_group = @registration.registration_groups.first
  end

  private
  
  def get_event_and_option
    @event = Event.find(params[:event_id] || session[:event_id])
    @event_option = @event.event_options.find(params[:event_option_id] || session[:event_option_id])
  end

  def check_for_open_event
    if @event.registration_closed?
      flash[:error] = "Sorry, registration is closed." and redirect_to(event_path(@event))
    end
  end

  def redirect_to_next_step
    current_step = session[:current_registration_step] || 0
    next_step = steps.index(current_step + 1)
    redirect_to :action => next_step
  end

  def set_progress_step
    if current_step = steps[self.action_name]
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
    return true
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

  def steps
    steps = {}
    current_step = 0
    unless @event.attendee_same_as_contact?
      current_step += 1
      steps["attendee_info"] = current_step
    end

    current_step += 1
    steps["contact_info"] = current_step

    if @event_option.has_menu?
      current_step += 1
      steps["menu"] = current_step
    end

    if @event_option.payment_required?
      current_step += 1
      steps["payment_type"] = current_step
      current_step += 1
      steps["payment_by_check"] = current_step
      steps["payment_by_credit_card"] = current_step
      steps["payment_by_elavon"] = current_step
      steps["poll_for_credit_card_payment"] = current_step
    end

    current_step += 1
    steps["confirmation"] = current_step
    steps
  end

  def ssl_required?
    true
  end

end
