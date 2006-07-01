module Admin::PageHelper
  def render_node(page, locals = {})
    locals.reverse_merge!( :level => 0, :simple => false ).merge!( :page => page )
    render :partial => 'node', :locals =>  locals
  end

  def expanded_rows
    if(cookie_string = (@cookies['expanded_rows']||[])[0])
        cookie_string.split(',').map {|x| x.to_i }
    else
        [(@homepage || Page.find_by_parent_id(nil)).id];
    end      
  end
  
  def meta_errors?
    !!(@page.errors[:slug] or @page.errors[:breadcrumb])
  end
end
