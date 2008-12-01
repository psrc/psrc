class Registration < ActiveRecord::Base
  has_many :registration_groups
  has_one  :payment
  belongs_to  :registration_contact
  belongs_to :event

  after_create :send_confirmation_email

  validates_presence_of :registration_contact
  validates_presence_of :payment, :if => :payment_required?
  validates_presence_of :registration_groups
  validates_presence_of :event

  def payment_amount
    read_attribute(:payment_amount) || calculate_payment_amount
  end

  def payment_required?
    self.payment_amount > 0
  end

  def event_attendees
    self.registration_groups.map { |g| g.event_attendees }.flatten
  end

  def number_of_attendees
    event_attendees.size
  end
  
  def invoiceable?
    self.payment.payment_method == "Credit Card"
  end

  private

  def calculate_payment_amount
    amount = 0
    self.registration_groups.each do |group|
      amount += group.event_option.price
    end
    amount
  end

  def send_confirmation_email
    # Note: failure to send the confirmation email shouldn't result in a failed registration.
    begin
      Emailer.deliver_registration_confirmation self
    rescue
      true
    end
  end
end
