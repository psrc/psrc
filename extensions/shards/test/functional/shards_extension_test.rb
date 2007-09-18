require File.dirname(__FILE__) + '/../test_helper'

class ShardsExtensionTest < Test::Unit::TestCase
  
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'shards'), ShardsExtension.root
    assert_equal 'Shards', ShardsExtension.extension_name
  end
  
  def test_should_create_page_edit_region_set
    admin = Radiant::AdminUI.instance
    assert_respond_to admin, :page
    assert_not_nil admin.page
    assert_instance_of OpenStruct, admin.page
    assert_not_nil admin.page.edit
    assert_instance_of Shards::RegionSet, admin.page.edit
    assert_equal %w{edit_header edit_form edit_popups}, admin.page.edit.main
    assert_equal %w{edit_title edit_extended_metadata
                              edit_page_parts edit_layout_and_type 
                              edit_timestamp}, admin.page.edit.form
    assert_equal %w{edit_buttons}, admin.page.edit.form_bottom
  end
  
  def test_should_add_render_region_helper
    assert ApplicationController.master_helper_module.included_modules.include?(Shards::HelperExtensions)
  end
end
