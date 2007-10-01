require File.dirname(__FILE__) + '/../test_helper'

class SchedulerExtensionTest < Test::Unit::TestCase
  fixtures :pages
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'scheduler'), SchedulerExtension.root
    assert_equal 'Scheduler', SchedulerExtension.extension_name
  end
  
  def test_should_scope_find_by_url
    assert_respond_to Page, :find_by_url_with_scheduling
    [:homepage, :unexpired, :unexpired_with_blank_start, :all_blank].each do |page|
      assert_not_nil Page.find_by_url(pages(page).url)
    end
    [:expired_with_blank_start, :unpublished, :unpublished_with_blank_end].each do |page|
      assert_nil Page.find_by_url(pages(page).url)
    end
    # When in 'dev' mode, find all pages, whether expired or not!
    [:homepage, :unexpired, :unexpired_with_blank_start, :all_blank, :expired_with_blank_start, :unpublished, :unpublished_with_blank_end].each do |page|
      assert_not_nil Page.find_by_url(pages(page).url, false)
    end
  end
end
