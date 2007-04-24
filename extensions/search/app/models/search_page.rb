class SearchPage < Page
  description "Provides tags and behavior to support searching Radiant.  Based on Oliver Baltzer's search_behavior."
   
  #### Tags ####
  desc %{    The namespace for all search tags.}
  tag 'search' do |tag|
    tag.expand
  end

  desc %{    <r:search:form [label="Search:"] />
    Renders a search form, with the optional label.}
  tag 'search:form' do |tag|
    label = tag.attr['label'].nil? ? "Search:" : tag.attr['label']
    content = %{<form action="#{self.url.chop}" method="get" id="search_form"><p><label for="q">#{label}</label> <input type="text" id="q" name="q" value="" size="15" /></p></form>}
    content << "\n"
  end
   
  desc %{    Renders the passed query.}
  tag 'search:query' do |tag|
    @query
  end
  
  desc %{    Renders the contained block if no results were returned.}
  tag 'search:empty' do |tag|
    if @query_result.empty?
      tag.expand
    end
  end
  
  desc %{    Renders the contained block if results were returned.}
  tag 'search:results' do |tag|
    if not @query_result.empty?
      tag.expand
    end
  end

  desc %{    Renders the contained block for each result page.  The context
    inside the tag refers to the found page.}
  tag 'search:results:each' do |tag|
    content = ''
    @query_result.each { |r|
      tag.locals.page = r
      content << tag.expand
    }
    content
  end
  
  desc %{    <r:truncate_and_strip [length="100"] />
    Truncates and strips all HTML tags from the content of the contained block.  
    Useful for displaying a snippet of a found page.  The optional `length' attribute
    specifies how many characters to truncate to.}
  tag 'truncate_and_strip' do |tag|
    length = tag.attr["length"].to_i || 100
    helper = ActionView::Base.new
    helper.truncate(helper.strip_tags(tag.expand).gsub(/\s+/," "), length)
  end
  
  #### "Behavior" methods ####
  def cache?
    false
  end
  
  def render
    @query_result = []
    @query = ""
    query = @request.parameters[:q]
    if not query.to_s.strip.empty?
      @query = query.to_s.strip
      tokens = query.split.collect { |c| "%#{c.downcase}%"}
      pages = Page.find(:all, :include => [ :parts ],
          :conditions => [(["((LOWER(content) LIKE ?) OR (LOWER(title) LIKE ?))"] * tokens.size).join(" AND "), 
                         *tokens.collect { |token| [token] * 2 }.flatten])
      @query_result = pages.delete_if { |p| !p.published? }
    end
    lazy_initialize_parser_and_context
    if layout
      parse_object(layout)
    else
      render_page_part(:body)
    end
  end
  
end