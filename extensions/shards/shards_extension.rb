# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'
require 'ostruct'

class ShardsExtension < Radiant::Extension
  version "0.3"
  description "Enables flexible manipulation of the administration user-interface."
  url "http://dev.radiantcms.org/svn/radiant/trunk/extensions/shards"
    
  def activate
    ApplicationController.send :helper, Shards::HelperExtensions
    #helpers aren't automatically inherited by already loaded classes
    ApplicationController.descendants.each do |controller|
      controller.send :helper, Shards::HelperExtensions
    end
    Radiant::AdminUI.class_eval do
      attr_accessor :page, :snippet, :layout
    end
    # initialize regions for page, snippet and layout
    admin.page = load_default_page_regions
    admin.snippet = load_default_snippet_regions
    admin.layout = load_default_layout_regions
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
        page.remove = page.children = page.index
        page.add_part = page.edit
        page
    end

    def load_default_snippet_regions
      snippet = OpenStruct.new
      snippet.edit = Shards::RegionSet.new do |edit|
        edit.main.concat %w{edit_header edit_form}
      end
      snippet
    end

    def load_default_layout_regions
      layout = OpenStruct.new
      layout.edit = Shards::RegionSet.new do |edit|
        edit.main.concat %w{edit_header edit_form}
      end
      layout
    end
end

