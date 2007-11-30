require File.dirname(__FILE__) + '/../spec_helper'

describe LocalTime do
  
  before :all do
    @conf = Radiant::Config
    @time = Time.gm(2004) 
  end
  
  def test_adjust_time_with_no_timezone
    new_time = adjust_time(@time)
    new_time.should == @time
  end 
  
  def test_adjust_time_with_garbage_timezone 
    @conf["local.timezone"] = "Timezone that doesn't exist" 
    new_time = adjust_time(@time) 
    new_time.should == @time
  end 
  
  def test_adjust_time_with_numeric_timezone 
    offset = -10.hours # Hawaii 
    @conf["local.timezone"] = offset
    hawaii_time = adjust_time(@time) 
    (hawaii_time - @time).should == offset
  end 

  def test_adjust_time_with_string_timezone 
    @conf["local.timezone"] = "Tokyo"
    tokyo_time = adjust_time(@time) 
    offset = 9.hours  # Tokyo is at +9:00 
    (tokyo_time - @time).should == offset
  end 
  
end
