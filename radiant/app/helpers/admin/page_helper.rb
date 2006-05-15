module Admin::PageHelper
  def render_node(page, locals = {})
    locals.reverse_merge!( :level => 0, :expand => 3, :simple => false ).merge!( :page => page )
    render :partial => 'node', :locals =>  locals
  end
  
  def meta_errors?
    !!(@page.errors[:slug] or @page.errors[:breadcrumb])
  end
end
