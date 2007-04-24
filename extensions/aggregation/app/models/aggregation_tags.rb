module AggregationTags
  include Radiant::Taggable
  
  desc %{
    Aggregates the children of multiple URLs using the @urls@ attribute.
    Useful for combining many different sections/categories into a single
    feed or listing.
    
    *Usage*:
    
    <pre><code><r:aggregate urls="/section1; /section2; /section3"> ... </r:aggregate></code></pre>
  }
  tag "aggregate" do |tag|
    raise "`urls' attribute required" unless tag.attr["urls"]
    urls = tag.attr["urls"].split(";").map(&:strip).reject(&:blank?).map { |u| clean_url u }
    parent_ids = urls.map {|u| Page.find_by_url(u) }.map(&:id)
    tag.locals.parent_ids = parent_ids
    tag.expand
  end
  
  tag "aggregate:children" do |tag|
    tag.expand
  end
  
  desc %{
    Renders the total count of children of the aggregated pages.  Accepts the
    same options as @<r:children:each />@.

    *Usage*:
    
    <pre><code><r:aggregate urls="/section1; /section2; /section3">
      <r:children:count />
    </r:aggregate></code></pre>
  }  
  tag "aggregate:children:count" do |tag|
    options = aggregate_children(tag)
    Page.count(options)
  end
  desc %{
    Renders the contained block for each child of the aggregated pages.  Accepts the
    same options as the plain @<r:children:each />@.

    *Usage*:
    
    <pre><code><r:aggregate urls="/section1; /section2; /section3">
      <r:children:each>
        ...
      </r:children:each>
    </r:aggregate></code></pre>
  }
  tag "aggregate:children:each" do |tag|
    options = aggregate_children(tag)
    children = Page.find(:all, options)
    tag.locals.previous_headers = {}
    returning String.new do |output|
      children.each do |child|
        tag.locals.page = child
        tag.locals.child = child
        output << tag.expand
      end
    end
  end
  
  desc %{
    Renders the first child of the aggregated pages.  Accepts the
    same options as @<r:children:each />@.

    *Usage*:
    
    <pre><code><r:aggregate urls="/section1; /section2; /section3">
      <r:children:first>
        ...
      </r:children:first>
    </r:aggregate></code></pre>
  }
  tag "aggregate:children:first" do |tag|
    options = aggregate_children(tag)
    children = Page.find(:all, options)
    if first = children.first
      tag.locals.page = first
      tag.expand
    end
  end
  
  desc %{
    Renders the last child of the aggregated pages.  Accepts the
    same options as @<r:children:each />@.

    *Usage*:
    
    <pre><code><r:aggregate urls="/section1; /section2; /section3">
      <r:children:last>
        ...
      </r:children:last>
    </r:aggregate></code></pre>
  }
  tag "aggregate:children:last" do |tag|
    options = aggregate_children(tag)
    children = Page.find(:all, options)
    if last = children.last
      tag.locals.page = last
      tag.expand
    end
  end
  
  def aggregate_children(tag)
    options = children_find_options(tag)
    parent_ids = tag.locals.parent_ids
    
    conditions = options[:conditions]
    conditions.first << " AND parent_id IN (?)"
    conditions << parent_ids
    options
  end
end