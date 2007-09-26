require File.dirname(__FILE__) + '/../test_helper'

class ExtensionLoaderTest < Test::Unit::TestCase
  
  def setup
    @config = Radiant::Configuration.new
    @config.extension_paths = [ "#{TEST_ROOT}/fixtures/extensions"]
    @init = Radiant::Initializer.new(@config)
    require 'radiant/extension_loader'
  end
  
  def test_load_all_alphabetically_if_none_specified
    @config.extensions = nil
    assert_extension_load_order %w{basic overriding load_order_blue load_order_green load_order_red}
  end
  
  def test_only_specified_extensions_loaded
    @config.extensions = [:basic, :load_order_green]
    assert_extension_load_order %w{basic load_order_green}
  end
  
  def test_specified_extension_load_order_with_all_at_end
    @config.extensions = [:load_order_green, :all]
    assert_extension_load_order %w{load_order_green basic overriding load_order_blue load_order_red}
  end  
  
  def test_specified_extension_load_order_with_all_at_start
    @config.extensions = [:all, :load_order_blue]
    assert_extension_load_order %w{basic overriding load_order_green load_order_red load_order_blue}
  end  

  def test_specified_extension_load_order_with_all_in_middle
    @config.extensions = [:load_order_green, :all, :basic]
    assert_extension_load_order %w{load_order_green overriding load_order_blue load_order_red basic}
  end  

  private
    def assert_extension_load_order(requested_extension_names)
      extension_paths = Radiant::ExtensionLoader.instance { |l| l.initializer = @init }.discover_extensions
      extension_names = extension_paths.map {|p| File.basename(p).sub(/^\d+_/,'')}
      assert_equal requested_extension_names, extension_names
    end
end
