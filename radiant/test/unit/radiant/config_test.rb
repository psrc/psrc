require File.dirname(__FILE__) + '/../../test_helper'
require 'radiant/config'

class Radiant::ConfigTest < Test::Unit::TestCase
  fixtures 'radiant/config'

  def setup
    @conf = Radiant::Config
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
end
