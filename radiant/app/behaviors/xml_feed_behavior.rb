class XMLFeedBehavior < Behavior::Base
  
  register "XML Feed"
  
  description %{
    Modifies page headers so that the content type is set to text/xml.
    Adds the following tags:
    - <r:escape_html></r:escape_html> 
    - <r:rfc1123_date />
  }
  
  def page_headers
    super.merge('Content-Type' => 'text/xml')
  end
  
  define_tags do
    tag "escape_html" do |tag|
      CGI.escapeHTML(tag.expand)
    end
    
    tag "rfc1123_date" do |tag|
      page = tag.locals.page
      if date = page.published_at || page.created_at
        CGI.rfc1123_date(date.to_time)
      end
    end
  end
  
end
