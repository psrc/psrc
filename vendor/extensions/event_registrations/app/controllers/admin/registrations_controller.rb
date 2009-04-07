require 'csv'
class Admin::RegistrationsController < ApplicationController
  before_filter :load_event
  def show
  end

  def export
    buf = ''
    header = ["Contact Name", "Contact Address", "Contact Phone", "Contact Email", "Attendees"]
    CSV.generate_row header, header.size, buf
    @event.registrations.each do |r|
      a = []
      a << r.registration_contact.name
      a << r.registration_contact.formatted_address
      a << r.registration_contact.phone
      a << r.registration_contact.email
      r.event_attendees.each do |e|
        a << e.to_s
      end
      CSV.generate_row a, a.size, buf
    end
    send_data buf, :type => "text/csv", :filename => "#{@event.name} registrations.csv"
  end

  private
  
  def load_event
    @event = Event.find params[:id]
  end

end
