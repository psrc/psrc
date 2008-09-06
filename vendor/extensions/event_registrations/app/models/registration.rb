class Registration < ActiveRecord::Base
  has_many :registration_groups
  has_one  :payment
  belongs_to  :registration_contact
  after_create :send_confirmation_email
  belongs_to :event

  validates_presence_of :registration_contact
  validates_presence_of :payment
  validates_presence_of :registration_groups
  validates_presence_of :event

  def payment_amount
    read_attribute(:payment_amount) || calculate_payment_amount
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
    Emailer.deliver_registration_confirmation self
  end
end
