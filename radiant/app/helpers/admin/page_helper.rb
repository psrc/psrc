module Admin::PageHelper
  def render_node(page, locals = {})
    locals.reverse_merge!(:level => 0, :simple => false).merge!(:page => page)
    render :partial => 'node', :locals =>  locals
  end

  def expanded_rows
    rows = case
    when row_string = (cookies['expanded_rows'] || []).first
      row_string.split(',').map { |x| Integer(x) rescue nil }.compact
    else
      []
    end
    (rows << homepage.id).uniq if homepage
    rows
  end
  
  def meta_errors?
    !!(@page.errors[:slug] or @page.errors[:breadcrumb])
  end
  
  def tag_reference(class_name)
    returning String.new do |output|
      class_name.constantize.tag_descriptions.sort.each do |tag_name, description|
        output << render(:partial => "tag_reference", 
            :locals => {:tag_name => tag_name, :description => description})
      end
    end
  end
  
  def filter_reference(filter_name)
    unless filter_name.blank?
      filter_class = (filter_name + "Filter").constantize
      filter_class.description.blank? ? "There is no documentation on this filter." : filter_class.description
    else
      "There is no filter on the current page part."
    end
  end
  
  def default_filter_name
    @page.parts.empty? ? "" : @page.parts[0].filter_id
  end
  
  def homepage
    @homepage ||= Page.find_by_parent_id(nil)
  end
end
