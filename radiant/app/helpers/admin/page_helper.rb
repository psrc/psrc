module Admin::PageHelper
  def render_node(page, locals = {})
    locals.reverse_merge!( :level => 0, :expand => 3, :simple => false ).merge!( :page => page )
    render :partial => 'node', :locals =>  locals
  end
  
  def toggle_metadata_javascript
    "javascript: Element.toggle('extended-metadata', 'more-metadata', 'less-metadata')"
  end
  
  def visible(symbol)
    meta_visible = (@page.errors[:slug] or @page.errors[:breadcrumb]) and true
    v = case symbol
    when :meta_more
      not meta_visible
    when :meta, :meta_less
      meta_visible
    end
    ' style="display: none"' unless v
  end
end
