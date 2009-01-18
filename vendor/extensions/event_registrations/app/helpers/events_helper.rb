module EventsHelper

  def changeable?
    RAILS_ENV != "production"
  end

  def date_span event
    #txt = event.start_date.strftime("%b %d")
    #txt << "- #{event.end_date.strftime("%b %d")}" if event.start_date != event.end_date
    #return txt
    relative_date_span [event.start_date, event.end_date]
  end
  
  def progress_step name
    @step ||= 0
    @step += 1
    current = (@step == @progress_step)
    # Adding <b> if current in case stylesheet is not included
    "<li class='step-#{@step}#{' current' if current}'>#{"<b>" if current}#{ name }#{"</b>" if current}</li>"
  end
  
  def state_province_options
    [['Alabama', 'AL'],
    ['Alaska', 'AK'],
    ['Arizona', 'AZ'],
    ['Arkansas', 'AR'],
    ['California', 'CA'],
    ['Colorado', 'CO'],
    ['Connecticut', 'CT'],
    ['Delaware', 'DE'],
    ['District Of Columbia', 'DC'],
    ['Florida', 'FL'],
    ['Georgia', 'GA'],
    ['Hawaii', 'HI'],
    ['Idaho', 'ID'],
    ['Illinois', 'IL'],
    ['Indiana', 'IN'],
    ['Iowa', 'IA'],
    ['Kansas', 'KS'],
    ['Kentucky', 'KY'],
    ['Louisiana', 'LA'],
    ['Maine', 'ME'],
    ['Maryland', 'MD'],
    ['Massachusetts', 'MA'],
    ['Michigan', 'MI'],
    ['Minnesota', 'MN'],
    ['Mississippi', 'MS'],
    ['Missouri', 'MO'],
    ['Montana', 'MT'],
    ['Nebraska', 'NE'],
    ['Nevada', 'NV'],
    ['New Hampshire', 'NH'],
    ['New Jersey', 'NJ'],
    ['New Mexico', 'NM'],
    ['New York', 'NY'],
    ['North Carolina', 'NC'],
    ['North Dakota', 'ND'],
    ['Ohio', 'OH'],
    ['Oklahoma', 'OK'],
    ['Oregon', 'OR'],
    ['Pennsylvania', 'PA'],
    ['Rhode Island', 'RI'],
    ['South Carolina', 'SC'],
    ['South Dakota', 'SD'],
    ['Tennessee', 'TN'],
    ['Texas', 'TX'],
    ['Utah', 'UT'],
    ['Vermont', 'VT'],
    ['Virginia', 'VA'],
    ['Washington', 'WA'],
    ['West Virginia', 'WV'],
    ['Wisconsin', 'WI'],
    ['Wyoming', 'WY'],
    ['Alberta', 'AB'],
    ['British Columbia','BC'],
    ['Manitoba','MB'],
    ['New Brunswick','NB'],
    ['Newfoundland and Labrador','NL'],
    ['Northwest Territories','NT'],
    ['Nova Scotia','NS'],
    ['Nunavut','NU'],
    ['Ontario','ON'],
    ['Prince Edward Island','PE'],
    ['Quebec','QC'],
    ['Saskatchewan','SK'],
    ['Yukon','YT']]
  end
  
end
