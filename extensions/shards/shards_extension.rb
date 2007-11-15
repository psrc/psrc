# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'
require 'ostruct'

class ShardsExtension < Radiant::Extension
  version "0.2"
  description "Enables flexible manipulation of the administration user-interface."
  url "http://seancribbs.com"
    
  def activate
    ApplicationController.send :helper, Shards::HelperExtensions
    #helpers aren't automatically inherited by already loaded classes
    ApplicationController.descendants.each do |controller|
      controller.send :helper, Shards::HelperExtensions
    end
    Radiant::AdminUI.class_eval do
      attr_accessor :page #, :snippet, :layout
    end
    admin.page = load_default_page_regions
    Admin::PageController.class_eval do
      before_filter :only => :add_part do |c|
        c.send :instance_variable_set, '@template_name', 'edit'
      end
    end
  end
  
  def deactivate
  end
  
  private
    def load_default_page_regions
        page = OpenStruct.new
        page.edit = Shards::RegionSet.new do |edit|
            edit.main.concat %w{edit_header edit_form edit_popups}
            edit.form.concat %w{edit_title edit_extended_metadata
                                  edit_page_parts}
            edit.form_bottom.concat %w{edit_buttons}
            edit.parts_bottom.concat %w{edit_layout_and_type edit_timestamp}
        end
        page.index = Shards::RegionSet.new do |index|
          index.sitemap_head.concat %w{title_column_header status_column_header
                                      modify_column_header}
          index.node.concat %w{title_column status_column add_child_column remove_column}
        end
        page.remove = page.index
        page.children = Shards::RegionSet.new   
        page
    end
  
end
