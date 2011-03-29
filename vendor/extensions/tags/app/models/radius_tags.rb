module RadiusTags
  include Radiant::Taggable
  include ActionView::Helpers::TextHelper
  
  class TagError < StandardError; end
  
  desc %{
    Find all pages with certain tags, within in an optional scope. Additionally, you may set with_any to true to select pages that have any of the listed tags (opposed to all listed tags which is the provided default).
    
    *Usage:*
    <pre><code><r:tagged with="shoes diesel" [scope="/fashion/cult-update"] [with_any="true"] [offset="number"] [limit="number"] [by="attribute"] [order="asc|desc"]>...</r:tagged></code></pre>
  }
  tag "tagged" do |tag|
    options = tagged_with_options(tag)
    with_any = tag.attr['with_any'] || false
    scope_attr = tag.attr['scope'] || '/'
    result = []
    raise TagError, "`tagged' tag must contain a `with' attribute." unless (tag.attr['with'] || tag.locals.page.class_name = TagSearchPage)
    ttag = tag.attr['with'] || @request.parameters[:tag]
    
    scope = scope_attr == 'current_page' ? tag.locals.page : Page.find_by_url(scope_attr)
    return "The scope attribute must be a valid url to an existing page." if scope.class_name.eql?('FileNotFoundPage')
    
    if with_any
      Page.tagged_with_any(ttag, options).each do |page|
          next unless (page.ancestors.include?(scope) or page == scope)
          tag.locals.page = page
          result << tag.expand
      end
    else
      Page.tagged_with(ttag, options).each do |page|
          next unless (page.ancestors.include?(scope) or page == scope)
          tag.locals.page = page
          result << tag.expand
      end
    end
    result
  end
  
  desc "Render a Tag cloud"
  tag "tag_cloud" do |tag|
    tag_cloud = MetaTag.cloud.sort
    output = "<ol class=\"tag_cloud\">"
    if tag_cloud.length > 0
    	build_tag_cloud(tag_cloud, %w(size1 size2 size3 size4 size5 size6 size7 size8 size9)) do |tag, cloud_class, amount|
    		output += "<li class=\"#{cloud_class}\"><span>#{pluralize(amount, 'page is', 'pages are')} tagged with </span><a href=\"#{tag_item_url(tag)}\" class=\"tag\">#{tag}</a></li>"
    	end
    else
    	return "<p>No tags found.</p>"
    end
    output += "</ol>"
  end
  
  desc "List the current page's tags"
  tag "tag_list" do |tag|
    output = []
    tag.locals.page.tag_list.split(" ").each {|t| output << "<a href=\"#{tag_item_url(t)}\" class=\"tag\">#{t}</a>"}
    output.join ", "
  end
  
  desc "Set the scope for all tags in the database"
  tag "all_tags" do |tag|
    tag.expand
  end
  
  desc %{
    Iterates through each tag and allows you to specify the order: by popularity or by name.
    The default is by name. You may also limit the search; the default is 5 results.
    
    Usage: <pre><code><r:all_tags:each order="popularity" limit="5">...</r:all_tags:each></code></pre>
  }
  tag "all_tags:each" do |tag|
    order = tag.attr['order'] || 'name'
    limit = tag.attr['limit'] || '5'
    result = []
    case order
    when 'name'
      all_tags = MetaTag.find(:all, :limit => limit)
    else
      all_tags = MetaTag.cloud(:limit => limit)
    end
    all_tags.each do |t|
      tag.locals.meta_tag = t
      result << tag.expand
    end
    result
  end
  
  desc "Renders the tag's name"
  tag "all_tags:each:name" do |tag|
    tag.locals.meta_tag.name
  end
  
  desc "Set the scope for the tag's pages"
  tag "all_tags:each:pages" do |tag|
    tag.expand
  end
  
  desc "Iterates through each page"
  tag "all_tags:each:pages:each" do |tag|
    result = []
    tag.locals.meta_tag.taggables.each do |taggable|
      if taggable.is_a?(Page)
        tag.locals.page = taggable
        result << tag.expand
      end
    end
    result
  end
  
  private
  
  def build_tag_cloud(tag_cloud, style_list)
    max, min = 0, 0
    tag_cloud.each do |tag|
      max = tag.popularity.to_i if tag.popularity.to_i > max
      min = tag.popularity.to_i if tag.popularity.to_i < min
    end
    
    divisor = ((max - min) / style_list.size) + 1

    tag_cloud.each do |tag|
      yield tag.name, style_list[(tag.popularity.to_i - min) / divisor], tag.popularity.to_i
    end
  end

  def tag_item_url(name)
    "#{Radiant::Config['tags.results_page_url']}?tag=#{name}"
  end
  
  def tagged_with_options(tag)
    attr = tag.attr.symbolize_keys
    
    options = {}
    
    [:limit, :offset].each do |symbol|
      if number = attr[symbol]
        if number =~ /^\d{1,4}$/
          options[symbol] = number.to_i
        else
          raise TagError.new("`#{symbol}' attribute of `each' tag must be a positive number between 1 and 4 digits")
        end
      end
    end
    
    by = (attr[:by] || 'published_at').strip
    order = (attr[:order] || 'asc').strip
    order_string = ''
    if self.attributes.keys.include?(by)
      order_string << by
    else
      raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
    end
    if order =~ /^(asc|desc)$/i
      order_string << " #{$1.upcase}"
    else
      raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
    end
    options[:order] = order_string
    
    status = (attr[:status] || 'published').downcase
    unless status == 'all'
      stat = Status[status]
      unless stat.nil?
        options[:conditions] = ["(virtual = ?) and (status_id = ?)", false, stat.id]
      else
        raise TagError.new(%{`status' attribute of `each' tag must be set to a valid status})
      end
    else
      options[:conditions] = ["virtual = ?", false]
    end
    options
  end
  
end