require File.dirname(__FILE__) + '/../spec_helper'

describe "StandardTags" do
  scenario :pages
  
  it 'should allow access to the current page through the page tag' do
    page(:home)
    page.should render('<r:page:title />').as('Home')
    page.should render(%{<r:find url="/radius"><r:title /> | <r:page:title /></r:find>}).as('Radius | Home')
  end
  
  it 'should provide tags for page attributes' do
    page(:home)
    [:breadcrumb, :slug, :title, :url].each do |attr|
      value = page.send(attr)
      page.should render("<r:#{attr} />").as(value.to_s)
    end
  end
  
  it 'should provide tags to iterate over children' do
    page(:parent)
    page.should render('<r:children:each><r:title /> </r:children:each>').as('Child Child 2 Child 3 ')
    page.should render('<r:children:each><r:page><r:slug />/<r:child:slug /> </r:page></r:children:each>').as('parent/child parent/child-2 parent/child-3 ')    
  end
  
  it 'should provide order options for iterating over children' do
    page.should render(page_children_each_tags).as('a b c d e f g h i j ')
    page.should render(page_children_each_tags(%{limit="5"})).as('a b c d e ')
    page.should render(page_children_each_tags(%{offset="3" limit="5"})).as('d e f g h ')
    page.should render(page_children_each_tags(%{order="desc"})).as('j i h g f e d c b a ')
    page.should render(page_children_each_tags(%{by="breadcrumb"})).as('f e d c b a j i h g ')
    page.should render(page_children_each_tags(%{by="breadcrumb" order="desc"})).as('g h i j a b c d e f ')
  end
  
  it 'should provide options for iterating over children that have a particular status' do
    page.should render(page_children_each_tags(%{status="all"})).as("a b c d e f g h i j draft ")
    page.should render(page_children_each_tags(%{status="draft"})).as('draft ')
    page.should render(page_children_each_tags(%{status="published"})).as('a b c d e f g h i j ')
    page.should render(page_children_each_tags(%{status="askdf"})).with_error("`status' attribute of `each' tag must be set to a valid status")
  end

  it 'should error when iterating over children with invalid limit option' do
    message = "`limit' attribute of `each' tag must be a positive number between 1 and 4 digits"
    page.should render(page_children_each_tags(%{limit="a"})).with_error(message)
    page.should render(page_children_each_tags(%{limit="-10"})).with_error(message)
    page.should render(page_children_each_tags(%{limit="50000"})).with_error(message)
  end
  
  it 'should error when iterating over children with invalid offset option' do
    message = "`offset' attribute of `each' tag must be a positive number between 1 and 4 digits"
    page.should render(%{offset="a"}).with_error(message)
    page.should render(%{offset="-10"}).with_error(message)
    page.should render(%{offset="50000"}).with_error(message)
  end
  
  private
    def page_children_each_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:each#{attr}><r:slug /> </r:children:each>"
    end
    
    def page(symbol = :assorted)
      @page ||= pages(symbol)
    end
end

# describe StandardTags do
#   scenarios :pages_with_layouts, :snippets, :users
#   test_helper :render
#   
#   specify 'tag children each attributes with invalid by field name' do
#     message = "`by' attribute of `each' tag must be set to a valid field name"
#     assert_render_error message, page_children_each_tags(%{by="non-existant-field"})
#   end
#   specify 'tag children each attributes with invalid limit' do
#     message = %{`order' attribute of `each' tag must be set to either "asc" or "desc"}
#     assert_render_error message, page_children_each_tags(%{order="asdf"})
#   end
#   specify 'tag children each does not list virtual pages' do
#     @page = pages(:assorted)
#     assert_renders 'a b c d e f g h i j ', '<r:children:each><r:slug /> </r:children:each>'
#     assert_render_match /^(draft |)a b c d e f g h i j( draft|) $/, '<r:children:each status="all"><r:slug /> </r:children:each>'
#   end
#   
#   specify 'tag children each header' do
#     @page = pages(:news)
#     assert_renders '[Jan/06] a-great-day-for-ruby [Feb/06] another-great-day-for-ruby later-that-day [Jan/07] next-year-in-ruby ', '<r:children:each><r:header>[<r:date format="%b/%y" />] </r:header><r:slug /> </r:children:each>'
#   end
#   specify 'tag children each header with name attribute' do
#     @page = pages(:news)
#     assert_renders '[2006] (Jan) a-great-day-for-ruby (Feb) another-great-day-for-ruby later-that-day [2007] (Jan) next-year-in-ruby ', %{<r:children:each><r:header name="year">[<r:date format='%Y' />] </r:header><r:header name="month">(<r:date format="%b" />) </r:header><r:slug /> </r:children:each>}  
#   end
#   specify 'tag children each header with restart attribute' do
#     @page = pages(:news)
#     assert_renders(
#       '[2006] (Jan) a-great-day-for-ruby (Feb) another-great-day-for-ruby later-that-day [2007] (Jan) next-year-in-ruby ',
#       %{<r:children:each><r:header name="year" restart="month">[<r:date format='%Y' />] </r:header><r:header name="month">(<r:date format="%b" />) </r:header><r:slug /> </r:children:each>}
#     )
#     assert_renders(
#       '[2006] (Jan) <30> a-great-day-for-ruby (Feb) <05> another-great-day-for-ruby <06> later-that-day [2007] (Jan) <30> next-year-in-ruby ',
#       %{<r:children:each><r:header name="year" restart="month;day">[<r:date format='%Y' />] </r:header><r:header name="month" restart="day">(<r:date format="%b" />) </r:header><r:header name="day"><<r:date format='%d' />> </r:header><r:slug /> </r:children:each>}
#     )
#   end
#   
#   specify 'tag children count' do
#     assert_renders '3', '<r:children:count />'
#   end
#   
#   specify 'tag children first' do
#     assert_renders 'Radius Test Child 1', '<r:children:first:title />'
#   end
#   specify 'tag children first parameters' do
#     @page = pages(:assorted)
#     assert_renders 'a', page_children_first_tags
#     assert_renders 'a', page_children_first_tags(%{limit="5"})
#     assert_renders 'd', page_children_first_tags(%{offset="3" limit="5"})
#     assert_renders 'j', page_children_first_tags(%{order="desc"})
#     assert_renders 'f', page_children_first_tags(%{by="breadcrumb"})
#     assert_renders 'g', page_children_first_tags(%{by="breadcrumb" order="desc"})
#   end
#   specify 'tag children first is nil' do
#     @page = pages(:textile)
#     assert_renders '', '<r:children:first:title />'
#   end
#   
#   specify 'tag children last' do
#     assert_renders 'Radius Test Child 3', '<r:children:last:title />'
#   end
#   specify 'tag children last parameters' do
#     @page = pages(:assorted)
#     assert_renders 'j', page_children_last_tags
#     assert_renders 'e', page_children_last_tags(%{limit="5"})
#     assert_renders 'h', page_children_last_tags(%{offset="3" limit="5"})
#     assert_renders 'a', page_children_last_tags(%{order="desc"})
#     assert_renders 'g', page_children_last_tags(%{by="breadcrumb"})
#     assert_renders 'f', page_children_last_tags(%{by="breadcrumb" order="desc"})
#   end
#   specify 'tag children last nil' do
#     @page = pages(:textile)
#     assert_renders '', '<r:children:last:title />'
#   end
#   
#   specify 'tag content' do
#     expected = "<h1>Radius Test Page</h1>\n\n\n\t<ul>\n\t<li>Radius Test Child 1</li>\n\t\t<li>Radius Test Child 2</li>\n\t\t<li>Radius Test Child 3</li>\n\t</ul>"
#     assert_renders expected, '<r:content />'
#   end
#   specify 'tag content with part attribute' do
#     assert_renders "Just a test.\n", '<r:content part="extended" />'
#   end
#   specify 'tag content with inherit attribute' do
#     assert_renders '', '<r:content part="sidebar" />'
#     assert_renders '', '<r:content part="sidebar" inherit="false" />'
#     assert_renders 'Radius Test Page sidebar.', '<r:content part="sidebar" inherit="true" />'
#     assert_render_error %{`inherit' attribute of `content' tag must be set to either "true" or "false"}, '<r:content part="sidebar" inherit="weird value" />'
#     
#     assert_renders '', '<r:content part="part_that_doesnt_exist" inherit="true" />'
#   end
#   specify 'tag content with inherit and contextual attributes' do
#     assert_renders 'Radius Test Page sidebar.', '<r:content part="sidebar" inherit="true" contextual="true" />'
#     assert_renders 'Ruby Home Page sidebar.', '<r:content part="sidebar" inherit="true" contextual="false" />'
#     
#     @page = pages(:inheritance_test_page_grandchild)
#     assert_renders 'Inheritance Test Page Grandchild inherited body.', '<r:content part="body" inherit="true" contextual="true" />'
#   end
#   specify 'tag content with inherit attribute grandparent' do
#     @page = pages(:child)
#     assert_renders '', '<r:content part="sidebar" />'
#     assert_renders 'Child sidebar.', '<r:content part="sidebar" inherit="true" />'
#     @page = pages(:parent)
#     assert_renders '', '<r:content part="sidebar" />'
#     assert_renders 'Parent sidebar.', '<r:content part="sidebar" inherit="true" />'
#   end
#   specify 'tag content with global page propagation' do
#     @page = pages(:global_child)
#     assert_renders 'Global Child Global Child', '<r:content part="titles" inherit="true" contextual="true"/>'
#     assert_renders 'Global Global Child', '<r:content part="titles" inherit="true" contextual="false"/>'
#   end
#   
#   specify 'tag child content' do
#     expected = "Radius test child 1 body.\nRadius test child 2 body.\nRadius test child 3 body.\n"
#     assert_renders expected, '<r:children:each><r:content /></r:children:each>'
#   end
#   
#   specify 'tag if content without body attribute' do
#     assert_renders 'true', '<r:if_content>true</r:if_content>'
#   end
#   specify 'tag if content with body attribute' do
#     assert_renders 'true', '<r:if_content part="body">true</r:if_content>'
#   end
#   specify 'tag if content with nonexistant body attribute' do
#     assert_renders '', '<r:if_content part="asdf">true</r:if_content>'
#   end
#   
#   specify 'tag unless content without body attribute' do
#     assert_renders '', '<r:unless_content>false</r:unless_content>'
#   end
#   specify 'tag unless content with body attribute' do
#     assert_renders '', '<r:unless_content part="body">false</r:unless_content>'
#   end
#   specify 'tag unless content with nonexistant body attribute' do
#     assert_renders 'false', '<r:unless_content part="asdf">false</r:unless_content>'
#   end
#   
#   specify 'tag author' do
#     assert_renders 'Admin User', '<r:author />'
#   end
#   specify 'tag author nil' do
#     @page = pages(:textile)
#     assert_renders '', '<r:author />'
#   end
#   
#   specify 'tag date' do
#     assert_renders 'Monday, January 30, 2006', '<r:date />'
#   end
#   specify 'tag date with format attribute' do
#     assert_renders '30 Jan 2006', '<r:date format="%d %b %Y" />'
#   end
#   specify 'tag date now' do
#     assert_renders Time.now.strftime("%A, %B %d, %Y"), '<r:date for="now" />'
#   end
#   specify 'tag date other attributes' do
#     assert_renders 'Monday, January 30, 2006', '<r:date for="created_at" />'
#     assert_renders 'Tuesday, January 31, 2006', '<r:date for="updated_at" />'
#     assert_renders 'Monday, January 30, 2006', '<r:date for="published_at" />'
#     assert_render_error "Invalid value for 'for' attribute.", '<r:date for="blah" />'
#   end
#   def test_tag_date_uses_local_timezone 
#     Radiant::Config["local.timezone"] = "Tokyo"
#     format = "%H:%m"
#     expected = TimeZone["Tokyo"].adjust(@page.published_at).strftime format 
#     assert_renders expected, %Q(<r:date format="#{format}" />) 
#   end
# 
#   specify 'tag link' do
#     assert_renders '<a href="/radius/">Radius Test Page</a>', '<r:link />'
#   end
#   specify 'tag link  attributes' do
#     expected = '<a href="/radius/" class="test" id="radius">Radius Test Page</a>'
#     assert_renders expected, '<r:link class="test" id="radius" />'
#   end
#   specify 'tag link  block form' do
#     assert_renders '<a href="/radius/">Test</a>', '<r:link>Test</r:link>'
#   end
#   specify 'tag link  anchor' do
#     assert_renders '<a href="/radius/#test">Test</a>', '<r:link anchor="test">Test</r:link>'
#   end
#   specify 'tag child link' do
#     expected = "<a href=\"/radius/child-1/\">Radius Test Child 1</a> <a href=\"/radius/child-2/\">Radius Test Child 2</a> <a href=\"/radius/child-3/\">Radius Test Child 3</a> "
#     assert_renders expected, '<r:children:each><r:link /> </r:children:each>' 
#   end
#   
#   specify 'tag snippet' do
#     assert_renders 'test', '<r:snippet name="first" />'
#   end
#   specify 'tag snippet not found' do
#     assert_render_error 'snippet not found', '<r:snippet name="non-existant" />'
#   end
#   specify 'tag snippet without name' do
#     assert_render_error "`snippet' tag must contain `name' attribute", '<r:snippet />'
#   end
#   specify 'tag snippet with markdown' do
#     assert_renders '<p><strong>markdown</strong></p>', '<r:page><r:snippet name="markdown" /></r:page>'
#   end
#   specify 'tag snippet with global page propagation' do
#     assert_renders "#{@page.title} " * @page.children.count, '<r:snippet name="global_page_cascade" />'
#   end
#   specify 'tag snippet with recursion global page propagation' do
#     @page = Page.find(6)
#     assert_renders "#{@page.title}" * 2, '<r:snippet name="recursive" />'
#   end
#   
#   specify 'tag random' do
#     assert_render_match /^(1|2|3)$/, "<r:random> <r:option>1</r:option> <r:option>2</r:option> <r:option>3</r:option> </r:random>"
#   end
#   
#   specify 'tag comment' do
#     assert_renders 'just a test', 'just a <r:comment>small </r:comment>test'
#   end
#   
#   def test_tag_navigation_1
#     tags = %{<r:navigation urls="Home: Boy: / | Archives: /archive/ | Radius: /radius/ | Docs: /documentation/">
#                <r:normal><a href="<r:url />"><r:title /></a></r:normal>
#                <r:here><strong><r:title /></strong></r:here>
#                <r:selected><strong><a href="<r:url />"><r:title /></a></strong></r:selected>
#                <r:between> | </r:between>
#              </r:navigation>}
#     expected = %{<strong><a href="/">Home: Boy</a></strong> | <a href="/archive/">Archives</a> | <strong>Radius</strong> | <a href="/documentation/">Docs</a>}
#     assert_renders expected, tags
#   end
#   def test_tag_navigation_2
#     tags = %{<r:navigation urls="Home: / | Archives: /archive/ | Radius: /radius/ | Docs: /documentation/">
#                <r:normal><r:title /></r:normal>
#              </r:navigation>}
#     expected = %{Home Archives Radius Docs}
#     assert_renders expected, tags
#   end
#   def test_tag_navigation_3
#     tags = %{<r:navigation urls="Home: / | Archives: /archive/ | Radius: /radius/ | Docs: /documentation/">
#                <r:normal><r:title /></r:normal>
#                <r:selected><strong><r:title/></strong></r:selected>
#              </r:navigation>}
#     expected = %{<strong>Home</strong> Archives <strong>Radius</strong> Docs}
#     assert_renders expected, tags
#   end
#   specify 'tag navigation without urls' do
#     assert_renders '', %{<r:navigation><r:normal /></r:navigation>}
#   end
#   specify 'tag navigation without normal tag' do
#     assert_render_error  "`navigation' tag must include a `normal' tag", %{<r:navigation urls="something:here"></r:navigation>}
#   end
#   specify 'tag navigation with urls without slashes' do
#     tags = %{<r:navigation urls="Home: | Archives: /archive | Radius: /radius | Docs: /documentation">
#                <r:normal><r:title /></r:normal>
#                <r:here><strong><r:title /></strong></r:here>
#              </r:navigation>}
#     expected = %{Home Archives <strong>Radius</strong> Docs}
#     assert_renders expected, tags
#   end
#   
#   specify 'tag find' do
#     assert_renders 'Ruby Home Page', %{<r:find url="/"><r:title /></r:find>}
#   end
#   specify 'tag find without url' do
#     assert_render_error "`find' tag must contain `url' attribute", %{<r:find />}
#   end
#   specify 'tag find with nonexistant url' do
#     assert_renders '', %{<r:find url="/asdfsdf/"><r:title /></r:find>}
#   end
#   specify 'tag find with nonexistant url and file not found' do
#     assert_renders '', %{<r:find url="/gallery/asdfsdf/"><r:title /></r:find>}
#   end
#   
#   specify 'tag find and children' do
#     assert_renders 'a-great-day-for-ruby another-great-day-for-ruby later-that-day next-year-in-ruby ', %{<r:find url="/news/"><r:children:each><r:slug /> </r:children:each></r:find>}
#   end
#   
#   specify 'tag escape html' do
#     assert_renders '&lt;strong&gt;a bold move&lt;/strong&gt;', '<r:escape_html><strong>a bold move</strong></r:escape_html>'
#   end
#   
#   def test_tag_rfc1123_date
#     @page.published_at = Time.utc(2004, 5, 2)
#     assert_renders 'Sun, 02 May 2004 00:00:00 GMT', '<r:rfc1123_date />'
#   end
#   
#   specify 'tag breadcrumbs' do
#     @page = pages(:deep_nested_child_for_breadcrumbs)
#     assert_renders '<a href="/">Home</a> &gt; <a href="/radius/">Radius Test Page</a> &gt; <a href="/radius/child-1/">Radius Test Child 1</a> &gt; Deeply nested child',
#       '<r:breadcrumbs />'
#   end
#   specify 'tag breadcrumbs with separator attribute' do
#     @page = pages(:deep_nested_child_for_breadcrumbs)
#     assert_renders '<a href="/">Home</a> :: <a href="/radius/">Radius Test Page</a> :: <a href="/radius/child-1/">Radius Test Child 1</a> :: Deeply nested child',
#       '<r:breadcrumbs separator=" :: " />'
#   end
#   
#   specify 'tag if url does not match' do
#     assert_renders '', '<r:if_url matches="fancypants">true</r:if_url>'
#   end
#   specify 'tag if url matches' do
#      assert_renders 'true', '<r:if_url matches="r.dius/$">true</r:if_url>'
#   end
#   specify 'tag if url without ignore case' do
#     assert_renders 'true', '<r:if_url matches="rAdius/$">true</r:if_url>'
#   end
#   specify 'tag if url with ignore case true' do
#     assert_renders 'true', '<r:if_url matches="rAdius/$" ignore_case="true">true</r:if_url>'
#   end
#   specify 'tag if url with ignore case false' do
#     assert_renders '', '<r:if_url matches="rAdius/$" ignore_case="false">true</r:if_url>'
#   end
#   specify 'tag if url with malformatted regexp' do
#     assert_render_error "Malformed regular expression in `matches' argument of `if_url' tag: unmatched (: /r(dius\\/$/", '<r:if_url matches="r(dius/$">true</r:if_url>'
#   end
#   specify 'tag if url empty' do
#     assert_render_error "`if_url' tag must contain a `matches' attribute.", '<r:if_url>test</r:if_url>'
#   end
#   
#   specify 'tag unless url does not match' do
#     assert_renders 'true', '<r:unless_url matches="fancypants">true</r:unless_url>'
#   end
#   specify 'tag unless url matches' do
#     assert_renders '', '<r:unless_url matches="r.dius/$">true</r:unless_url>'
#   end
#   specify 'tag unless url without ignore case' do
#     assert_renders '', '<r:unless_url matches="rAdius/$">true</r:unless_url>'
#   end
#   specify 'tag unless url with ignore case true' do
#     assert_renders '', '<r:unless_url matches="rAdius/$" ignore_case="true">true</r:unless_url>'
#   end
#   specify 'tag unless url with ignore case false' do
#     assert_renders 'true', '<r:unless_url matches="rAdius/$" ignore_case="false">true</r:unless_url>'
#   end
#   specify 'tag unless url with malformatted regexp' do
#     assert_render_error "Malformed regular expression in `matches' argument of `unless_url' tag: unmatched (: /r(dius\\/$/", '<r:unless_url matches="r(dius/$">true</r:unless_url>'
#   end
#   specify 'tag unless url empty' do
#     assert_render_error "`unless_url' tag must contain a `matches' attribute.", '<r:unless_url>test</r:unless_url>'
#   end
#   
#   specify 'tag cycle' do
#     assert_renders 'first second', '<r:cycle values="first, second" /> <r:cycle values="first, second" />'
#   end
#   specify 'tag cycle returns to beginning' do
#     assert_renders 'first second first', '<r:cycle values="first, second" /> <r:cycle values="first, second" /> <r:cycle values="first, second" />'
#   end
#   specify 'tag cycle default name' do
#     assert_renders 'first second', '<r:cycle values="first, second" /> <r:cycle values="first, second" name="cycle" />'
#   end
#   specify 'tag cycle keeps separate counters' do
#     assert_renders 'first one second two', '<r:cycle values="first, second" /> <r:cycle values="one, two" name="numbers" /> <r:cycle values="first, second" /> <r:cycle values="one, two" name="numbers" />'
#   end
#   specify 'tag cycle resets counter' do
#     assert_renders 'first first', '<r:cycle values="first, second" /> <r:cycle values="first, second" reset="true"/>'    
#   end
#   specify 'tag cycle names empty' do
#     assert_render_error "`cycle' tag must contain a `values' attribute.", '<r:cycle />'
#   end
#   
#   specify 'tag parent' do
#     assert_renders pages(:homepage).title, '<r:parent><r:title /></r:parent>'
#     assert_renders page_eachable_children(pages(:homepage)).collect(&:title).join(""), '<r:parent><r:children:each by="title"><r:title /></r:children:each></r:parent>'
#     assert_renders @page.title * @page.children.count, '<r:children:each><r:parent:title /></r:children:each>'
#   end
#   specify 'tag if parent' do
#     assert_renders 'true', '<r:if_parent>true</r:if_parent>'
#     @page = pages(:homepage)
#     assert_renders '', '<r:if_parent>true</r:if_parent>'
#   end
#   specify 'tag unless parent' do
#     assert_renders '', '<r:unless_parent>true</r:unless_parent>'
#     @page = pages(:homepage)
#     assert_renders 'true', '<r:unless_parent>true</r:unless_parent>'
#   end
#   
#   specify 'tag if children' do
#     @page = pages(:homepage)
#     assert_renders 'true', '<r:if_children>true</r:if_children>'
#     @page = pages(:childless)
#     assert_renders '', '<r:if_children>true</r:if_children>'
#   end
#   specify 'tag unless children' do
#     @page = pages(:homepage)
#     assert_renders '', '<r:unless_children>true</r:unless_children>'
#     @page = pages(:childless)
#     assert_renders 'true', '<r:unless_children>true</r:unless_children>'
#   end
#   
#   specify 'if dev' do
#     assert_renders '-dev-', '-<r:if_dev>dev</r:if_dev>-', nil , 'dev.site.com'
#     assert_renders '--', '-<r:if_dev>dev</r:if_dev>-'
#   end
#   specify 'if dev on included page' do
#     assert_renders '-dev-', '-<r:find url="/devtags/"><r:content part="if_dev" /></r:find>-', nil, 'dev.site.com'
#     assert_renders '--', '-<r:find url="/devtags/"><r:content part="if_dev" /></r:find>-'
#   end
#   
#   specify 'unless dev' do
#     assert_renders '--', '-<r:unless_dev>not dev</r:unless_dev>-', nil, 'dev.site.com'
#     assert_renders '-not dev-', '-<r:unless_dev>not dev</r:unless_dev>-'
#   end
#   specify 'unless dev on included page' do
#     assert_renders '--', '-<r:find url="/devtags/"><r:content part="unless_dev" /></r:find>-', nil, 'dev.site.com'
#     assert_renders '-not dev-', '-<r:find url="/devtags/"><r:content part="unless_dev" /></r:find>-'
#   end
#   
#   private
#   
#     def page_children_first_tags(attr = nil)
#       attr = ' ' + attr unless attr.nil?
#       "<r:children:first#{attr}><r:slug /></r:children:first>"
#     end
#     
#     def page_children_last_tags(attr = nil)
#       attr = ' ' + attr unless attr.nil?
#       "<r:children:last#{attr}><r:slug /></r:children:last>"
#     end
#     

#     
#     def page_eachable_children(page)
#       page.children.select(&:published?).reject(&:virtual)
#     end
#   
# end
