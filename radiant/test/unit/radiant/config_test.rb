require File.dirname(__FILE__) + '/../../test_helper'
require 'radiant/config'

class Radiant::ConfigTest < Test::Unit::TestCase
  def setup
    @conf = Radiant::Config
    set('test', 'cool')
    set('foo', 'bar')
  end
  
  def test_brackets
    assert_equal 'cool', @conf['test']
  end
  
  def test_brackets_with_non_existant_key
    assert_equal nil, @conf['non-existant-key']
  end
  
  def test_assign_to_brackets
    v = @conf['bar'] = 'baz'
    assert_equal 'baz', @conf['bar']
    assert_equal 'baz', v
  end
  
  def test_assign_to_brackets_existing_key
    @conf['foo'] = 'normal'
    v = @conf['foo'] = 'replaced'
    assert_equal 'replaced', @conf['foo']
    assert_equal 'replaced', v
  end

  def test_to_hash
    h = @conf.to_hash
    assert_instance_of Hash, h
    assert_equal 'cool', h['test']
    assert h.size > 1
  end
  
  def test_boolean_values
    set('bool?', true)
    assert @conf["bool?"]
    set('bool?', false)
    assert !@conf["bool?"]
    set('bool2', true)
    assert_equal 'true', @conf['bool2']
    set('bool2', :blahblahblah)
    assert_equal 'blahblahblah', @conf['bool2']
  end
  
  def test_adjust_time_with_no_timezone 
 	  time = Time.gm 2004 
    new_time = @conf.adjust_time(time)
    assert_equal time, new_time 
  end 

  def test_adjust_time_with_garbage_timezone 
    @conf["site.timezone"] = "Timezone that doesnt exist" 

    time = Time.gm 2004 
    new_time = @conf.adjust_time time 

    assert_equal time, new_time 
  end 

  def test_adjust_time_with_numeric_timezone 
    offset = -10.hours # Hawaii 
    @conf["site.timezone"] = offset 

    time = Time.gm 2004 
    hawaii_time = @conf.adjust_time time 
    assert_equal offset, hawaii_time - time 
  end 

  def test_adjust_time_with_string_timezone 
    @conf["site.timezone"] = "Tokyo" 
    time = Time.gm 2004 

    tokyo_time = @conf.adjust_time time 
    offset = 9.hours                   # Tokyo is at +9:00 
    assert_equal offset, tokyo_time - time 
  end 
  
  private
    def set(key, value)
      setting = Radiant::Config.find_by_key(key)
      setting.destroy if setting
      Radiant::Config.new(:key => key, :value => value).save
    end

end
