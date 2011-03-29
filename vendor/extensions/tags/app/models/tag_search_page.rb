class TagSearchPage < Page

  attr_accessor :query_result, :query
  #### Tags ####
  desc %{    The namespace for all search tags.}
  tag 'search' do |tag|
    tag.expand
  end

  desc %{    Renders the passed query.}
  tag 'search:query' do |tag|
    CGI.escapeHTML(query_as_array.to_sentence)
  end
  
  desc %{    Renders the contained block if no results were returned.}
  tag 'search:empty' do |tag|
    if query_result.blank?
      tag.expand
    end
  end
  
  desc %{    Renders the contained block if a query was specified.}
  tag 'search:query_present' do |tag|
    if !query.blank?
      tag.expand
    end
  end
  
  desc %{    Renders the contained block if results were returned.}
  tag 'search:results' do |tag|
    unless query_result.blank?
      tag.expand
    end
  end

  desc %{    Renders the contained block for each result page.  The context
    inside the tag refers to the found page.}
  tag 'search:results:each' do |tag|
    returning String.new do |content|
      query_result.each do |page|
        tag.locals.page = page
        content << tag.expand
      end
    end
  end
  
  desc %{    <r:truncate_and_strip [length="100"] />
    Truncates and strips all HTML tags from the content of the contained block.  
    Useful for displaying a snippet of a found page.  The optional `length' attribute
    specifies how many characters to truncate to.}
  tag 'truncate_and_strip' do |tag|
    tag.attr['length'] ||= 100
    length = tag.attr['length'].to_i
    helper = ActionView::Base.new
    helper.truncate(helper.strip_tags(tag.expand).gsub(/\s+/," "), length)
  end
  
  desc %{    <r:search:options options="list; of; options" />
    Renders a list of option tags for use in a select tag, selecting the ones that are in the current query}
  tag 'search:options' do |tag|
    (tag.attr['options'] || '').split(/;\s*/).collect do |o|
      "<option#{' selected="selected"' if query_as_array.include?(o)}>#{o}</option>"
    end.join('')
  end
  
  #### "Behavior" methods ####
  def cache?
    false
  end
  
  def render
    @query_result = []
    tag = @request.parameters[:tag]
    self.title = "Tag Search Results"
    unless (@query = tag).blank?
      @query_result = Page.tagged_with(tag).delete_if { |p| !p.published? }
    end
    lazy_initialize_parser_and_context
    if layout
      parse_object(layout)
    else
      render_page_part(:body)
    end
  end
  
  def query_as_array
    @query_as_array ||= query.nil? ? [] : (query.is_a?(Array) ? query : query.split(MetaTag::DELIMITER))
  end
  
end