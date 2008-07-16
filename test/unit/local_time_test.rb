require File.dirname(__FILE__) + '/../test_helper'

class MockClass; include LocalTime; end

class LocalTimeTest < Test::Unit::TestCase

  def setup
    @obj = MockClass.new
    @conf = Radiant::Config
  end
  
  def test_adjust_time_with_no_timezone 
    time = Time.gm 2004 
    new_time = @obj.adjust_time(time)
    assert_equal time, new_time 
  end 

  def test_adjust_time_with_garbage_timezone 
    @conf["local.timezone"] = "Timezone that doesnt exist" 

    time = Time.gm 2004 
    new_time = @obj.adjust_time time 

    assert_equal time, new_time 
  end 

  def test_adjust_time_with_numeric_timezone 
    offset = -10.hours # Hawaii 
    @conf["local.timezone"] = offset 

    time = Time.gm 2004 
    hawaii_time = @obj.adjust_time time 
    assert_equal offset, hawaii_time - time 
  end 

  def test_adjust_time_with_string_timezone 
    @conf["local.timezone"] = "Tokyo" 
    time = Time.gm 2004 

    tokyo_time = @obj.adjust_time time 
    offset = 9.hours  # Tokyo is at +9:00 
    assert_equal offset, tokyo_time - time 
  end 
  
end
