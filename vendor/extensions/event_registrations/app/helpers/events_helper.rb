module EventsHelper
  def date_span event
    #txt = event.start_date.strftime("%b %d")
    #txt << "- #{event.end_date.strftime("%b %d")}" if event.start_date != event.end_date
    #return txt
    relative_date_span [event.start_date, event.end_date]
  end
end
