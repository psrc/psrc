require File.dirname(__FILE__) + '/../spec_helper'

describe "Standard Tags" do
  scenario :users_and_pages, :file_not_found, :snippets
  
  specify '<r:page> should allow access to the current page' do
    page(:home)
    page.should render('<r:page:title />').as('Home')
    page.should render(%{<r:find url="/radius"><r:title /> | <r:page:title /></r:find>}).as('Radius | Home')
  end
  
  specify '<r:breadcrumb>, <r:slug>, <r:title>, and <r:url>' do
    page(:home)
    [:breadcrumb, :slug, :title, :url].each do |attr|
      value = page.send(attr)
      page.should render("<r:#{attr} />").as(value.to_s)
    end
  end
  
  specify '<r:url> with a relative URL root should scope to the relative root' do
    page(:home).should render("<r:url />").with_relative_root("/foo").as("/foo/")
  end
  
  specify '<r:parent>' do
    page(:parent)
    page.should render('<r:parent><r:title /></r:parent>').as(pages(:home).title)
    page.should render('<r:parent><r:children:each by="title"><r:title /></r:children:each></r:parent>').as(page_eachable_children(pages(:home)).collect(&:title).join(""))
    page.should render('<r:children:each><r:parent:title /></r:children:each>').as(@page.title * page.children.count)
  end
  
  specify '<r:if_parent>' do
    page.should render('<r:if_parent>true</r:if_parent>').as('true')
    page(:home).should render('<r:if_parent>true</r:if_parent>').as('')
  end
  
  specify '<r:unless_parent>' do
    page.should render('<r:unless_parent>true</r:unless_parent>').as('')
    page(:home).should render('<r:unless_parent>true</r:unless_parent>').as('true')
  end
  
  specify '<r:if_children>' do
    page(:home).should render('<r:if_children>true</r:if_children>').as('true')
    page(:childless).should render('<r:if_children>true</r:if_children>').as('')
  end
  
  specify '<r:unless_children>' do
    page(:home).should render('<r:unless_children>true</r:unless_children>').as('')
    page(:childless).should render('<r:unless_children>true</r:unless_children>').as('true')
  end
  
  specify '<r:children:each>' do
    page(:parent)
    page.should render('<r:children:each><r:title /> </r:children:each>').as('Child Child 2 Child 3 ')
    page.should render('<r:children:each><r:page><r:slug />/<r:child:slug /> </r:page></r:children:each>').as('parent/child parent/child-2 parent/child-3 ')    
  end
  specify '<r:children:each> order attributes' do
    page.should render(page_children_each_tags).as('a b c d e f g h i j ')
    page.should render(page_children_each_tags(%{limit="5"})).as('a b c d e ')
    page.should render(page_children_each_tags(%{offset="3" limit="5"})).as('d e f g h ')
    page.should render(page_children_each_tags(%{order="desc"})).as('j i h g f e d c b a ')
    page.should render(page_children_each_tags(%{by="breadcrumb"})).as('f e d c b a j i h g ')
    page.should render(page_children_each_tags(%{by="breadcrumb" order="desc"})).as('g h i j a b c d e f ')
  end
  specify '<r:children:each> with "status" attribute' do
    page.should render(page_children_each_tags(%{status="all"})).as("a b c d e f g h i j draft ")
    page.should render(page_children_each_tags(%{status="draft"})).as('draft ')
    page.should render(page_children_each_tags(%{status="published"})).as('a b c d e f g h i j ')
    page.should render(page_children_each_tags(%{status="askdf"})).with_error("`status' attribute of `each' tag must be set to a valid status")
  end
  specify '<r:children:each> should not list virtual pages' do
    page.should render('<r:children:each><r:slug /> </r:children:each>').as('a b c d e f g h i j ') 
    page.should render('<r:children:each status="all"><r:slug /> </r:children:each>').as('a b c d e f g h i j draft ')
  end
  specify '<r:children:each> should error with invalid "limit" attribute' do
    message = "`limit' attribute of `each' tag must be a positive number between 1 and 4 digits"
    page.should render(page_children_each_tags(%{limit="a"})).with_error(message)
    page.should render(page_children_each_tags(%{limit="-10"})).with_error(message)
    page.should render(page_children_each_tags(%{limit="50000"})).with_error(message)
  end
  specify '<r:children:each> should error with invalid "offset" attribute' do
    message = "`offset' attribute of `each' tag must be a positive number between 1 and 4 digits"
    page.should render(%{offset="a"}).with_error(message)
    page.should render(%{offset="-10"}).with_error(message)
    page.should render(%{offset="50000"}).with_error(message)
  end
  specify '<r:children:each> should error with invalid "by" attribute' do
    message = "`by' attribute of `each' tag must be set to a valid field name"
    page.should render(page_children_each_tags(%{by="non-existant-field"})).with_error(message)
  end
  specify '<r:children:each> should error with invalid "order" attribute' do
    message = %{`order' attribute of `each' tag must be set to either "asc" or "desc"}
    page.should render(page_children_each_tags(%{order="asdf"})).with_error(message)
  end
  
  specify '<r:children:each:header>' do
    tags = '<r:children:each><r:header>[<r:date format="%b/%y" />] </r:header><r:slug /> </r:children:each>'
    expected = "[Dec/00] article [Feb/01] article-2 article-3 [Mar/01] article-4 "
    page(:news).should render(tags).as(expected)
  end
  specify '<r:children:each:header> with "name" attribute' do
    tags = %{<r:children:each><r:header name="year">[<r:date format='%Y' />] </r:header><r:header name="month">(<r:date format="%b" />) </r:header><r:slug /> </r:children:each>}
    expected = "[2000] (Dec) article [2001] (Feb) article-2 article-3 (Mar) article-4 "
    page(:news).should render(tags).as(expected)
  end
  specify '<r:children:each:header> with "restart" attribute set to one name' do
    tags = %{<r:children:each><r:header name="year" restart="month">[<r:date format='%Y' />] </r:header><r:header name="month">(<r:date format="%b" />) </r:header><r:slug /> </r:children:each>}
    expected = "[2000] (Dec) article [2001] (Feb) article-2 article-3 (Mar) article-4 "
    page(:news).should render(tags).as(expected)
  end
  specify '<r:children:each:header> with "restart" attribute set to two names' do
    tags = %{<r:children:each><r:header name="year" restart="month;day">[<r:date format='%Y' />] </r:header><r:header name="month" restart="day">(<r:date format="%b" />) </r:header><r:header name="day"><<r:date format='%d' />> </r:header><r:slug /> </r:children:each>}
    expected = "[2000] (Dec) <01> article [2001] (Feb) <09> article-2 <24> article-3 (Mar) <06> article-4 "
    page(:news).should render(tags).as(expected)
  end
  
  specify '<r:children:count>' do
    page(:parent).should render('<r:children:count />').as('3')
  end
  
  specify '<r:children:first>' do
    page(:parent).should render('<r:children:first:title />').as('Child') 
  end  
  specify '<r:children:first> with attributes' do
    page.should render(page_children_first_tags).as('a') 
    page.should render(page_children_first_tags(%{limit="5"})).as('a')
    page.should render(page_children_first_tags(%{offset="3" limit="5"})).as('d')
    page.should render(page_children_first_tags(%{order="desc"})).as('j')
    page.should render(page_children_first_tags(%{by="breadcrumb"})).as('f')
    page.should render(page_children_first_tags(%{by="breadcrumb" order="desc"})).as('g')
  end
  specify '<r:children:first> when no children exist' do
    page(:first).should render('<r:children:first:title />').as('')
  end
  
  specify '<r:children:last>' do
    page(:parent).should render('<r:children:last:title />').as('Child 3')
  end
  specify '<r:children:last> with attributes' do
    page.should render(page_children_last_tags).as('j')
    page.should render(page_children_last_tags(%{limit="5"})).as('e')
    page.should render(page_children_last_tags(%{offset="3" limit="5"})).as('h')
    page.should render(page_children_last_tags(%{order="desc"})).as('a')
    page.should render(page_children_last_tags(%{by="breadcrumb"})).as('g')
    page.should render(page_children_last_tags(%{by="breadcrumb" order="desc"})).as('f')
  end
  specify '<r:children:last> when no children exist' do
    page(:first).should render('<r:children:last:title />').as('')
  end
  
  specify '<r:content>' do
    page.should render('<r:content />').as('Assorted body.')
  end
  specify '<r:content> with "part" attribute' do
    page(:home).should render('<r:content part="extended" />').as("Just a test.")
  end
  specify '<r:content> with inherit attribute' do
    page.should render('<r:content part="sidebar" />').as('')
    page.should render('<r:content part="sidebar" inherit="false" />').as('')
    page.should render('<r:content part="sidebar" inherit="true" />').as('Assorted sidebar.')
    page.should render('<r:content part="sidebar" inherit="weird value" />').with_error(%{`inherit' attribute of `content' tag must be set to either "true" or "false"})
    page.should render('<r:content part="part_that_doesnt_exist" inherit="true" />').as('')
  end
  specify '<r:content> with inherit and contextual attributes' do
    page(:parent)
    page.should render('<r:content part="sidebar" inherit="true" contextual="true" />').as('Parent sidebar.')
    page.should render('<r:content part="sidebar" inherit="true" contextual="false" />').as('Home sidebar.')
    page(:child).should render('<r:content part="sidebar" inherit="true" contextual="true" />').as('Child sidebar.')
    page(:grandchild).should render('<r:content part="sidebar" inherit="true" contextual="true" />').as('Grandchild sidebar.')
  end
  specify '<r:content> with global page propagation' do
    page(:first)
    page.should render('<r:content part="titles" inherit="true" contextual="true"/>').as('First First')
    page.should render('<r:content part="titles" inherit="true" contextual="false"/>').as('Home First')
  end
  specify '<r:content /> for children' do
    expected = "Child body. Child 2 body. Child 3 body. "
    page(:parent).should render('<r:children:each><r:content /> </r:children:each>').as(expected)
  end
  
  specify '<r:if_content> without "part" attribute' do
    page.should render('<r:if_content>true</r:if_content>').as('true')
  end
  specify '<r:if_content> with "part" attribute' do
    page.should render('<r:if_content part="body">true</r:if_content>').as('true')
  end
  specify '<r:if_content> with nonexistant "part" attribute' do
    page.should render('<r:if_content part="asdf">true</r:if_content>').as('')
  end
  
  specify '<r:unless_content> without "part" attribute' do
    page.should render('<r:unless_content>false</r:unless_content>').as('')
  end
  specify '<r:unless_content> with "part" attribute' do
    page.should render('<r:unless_content part="body">false</r:unless_content>').as('')
  end
  specify '<r:unless_content> with nonexistant "part" attribute' do
    page.should render('<r:unless_content part="asdf">false</r:unless_content>').as('false')
  end
  
  specify '<r:author>' do
    page.should render('<r:author />').as('Admin')
  end
  specify '<r:author> nil' do
    page(:no_user).should render('<r:author />').as('')
  end
  
  specify '<r:date>' do
    page(:dated)
    page.should render('<r:date />').as('Wednesday, January 11, 2006')
  end
  specify '<r:date> with "format" attribute' do
    page(:dated)
    page.should render('<r:date format="%d %b %Y" />').as('11 Jan 2006')
  end
  specify '<r:date> with "for" attribute' do
    page(:dated)
    page.should render('<r:date for="now" />').as(Time.now.strftime("%A, %B %d, %Y"))
    page.should render('<r:date for="created_at" />').as('Tuesday, January 10, 2006')
    page.should render('<r:date for="updated_at" />').as('Thursday, January 12, 2006')
    page.should render('<r:date for="published_at" />').as('Wednesday, January 11, 2006')
    page.should render('<r:date for="blah" />').with_error("Invalid value for 'for' attribute.")
  end
  specify '<r:date> should use local timezone' do
    page(:dated)
    Radiant::Config["local.timezone"] = "Tokyo"
    format = "%H:%m"
    expected = TimeZone["Tokyo"].adjust(page.published_at).strftime(format)
    page.should render(%Q(<r:date format="#{format}" />) ).as(expected)
  end
  
  specify '<r:link>' do
    page.should render('<r:link />').as('<a href="/assorted/">Assorted</a>')
  end
  specify '<r:link> in block form' do
    page.should render('<r:link>Test</r:link>').as('<a href="/assorted/">Test</a>')
  end
  specify '<r:link> with HTML attributes' do
    expected = '<a href="/assorted/" class="test" id="assorted">Assorted</a>'
    page.should render('<r:link class="test" id="assorted" />').as(expected)
  end
  specify '<r:link> with "anchor" attribute' do
    page.should render('<r:link anchor="test">Test</r:link>').as('<a href="/assorted/#test">Test</a>')
  end
  specify '<r:link> should work for children' do
    expected = %{<a href="/parent/child/">Child</a> <a href="/parent/child-2/">Child 2</a> <a href="/parent/child-3/">Child 3</a> }
    page(:parent).should render('<r:children:each><r:link /> </r:children:each>' ).as(expected)
  end
  specify '<r:link> with a relative URL root should scope to the relative root' do
    page(:assorted).should render('<r:link />').with_relative_root('/foo').as('<a href="/foo/assorted/">Assorted</a>')
  end
  
  specify '<r:snippet>' do
    page.should render('<r:snippet name="first" />').as('test')
  end
  specify '<r:snippet> not found' do
    page.should render('<r:snippet name="non-existant" />').with_error('snippet not found')
  end
  specify '<r:snippet> without name' do
    page.should render('<r:snippet />').with_error("`snippet' tag must contain `name' attribute")
  end
  specify '<r:snippet> with markdown' do
    page.should render('<r:page><r:snippet name="markdown" /></r:page>').as('<p><strong>markdown</strong></p>')
  end
  specify '<r:snippet> with global page propagation' do
    page(:parent).should render('<r:snippet name="global_page_cascade" />').as("#{@page.title} " * @page.children.count)
  end
  specify '<r:snippet> with recursion global page propagation' do
    page(:child).should render('<r:snippet name="recursive" />').as("Great GrandchildGrandchildChild")
  end
  
  specify '<r:random>' do
    page.should render("<r:random> <r:option>1</r:option> <r:option>2</r:option> <r:option>3</r:option> </r:random>").matching(/^(1|2|3)$/) 
  end
  
  specify '<r:comment>' do
    page.should render('just a <r:comment>small </r:comment>test').as('just a test')
  end
  
  specify '<r:navigation> simple case' do
    tags = %{<r:navigation urls="Home: / | Assorted: /assorted/ | Parent: /parent/">
               <r:normal><r:title /></r:normal>
             </r:navigation>}
    expected = %{Home Assorted Parent}
    page.should render(tags).as(expected)
  end
  specify '<r:navigation> more complex' do
    tags = %{<r:navigation urls="Home: / | Assorted: /assorted/ | Parent: /parent/ | Radius: /radius/">
               <r:normal><r:title /></r:normal>
               <r:selected><strong><r:title/></strong></r:selected>
             </r:navigation>}
    expected = %{<strong>Home</strong> Assorted <strong>Parent</strong> Radius}
    page(:parent).should render(tags).as(expected)
  end
  specify '<r:navigation> very complex' do
    tags = %{<r:navigation urls="Home: Boy: / | Assorted: /assorted/ | Parent: /parent/">
               <r:normal><a href="<r:url />"><r:title /></a></r:normal>
               <r:here><strong><r:title /></strong></r:here>
               <r:selected><strong><a href="<r:url />"><r:title /></a></strong></r:selected>
               <r:between> | </r:between>
             </r:navigation>}
    expected = %{<strong><a href="/">Home: Boy</a></strong> | <strong>Assorted</strong> | <a href="/parent/">Parent</a>}
    page.should render(tags).as(expected)
  end
  specify '<r:navigation> without urls' do
    page.should render(%{<r:navigation><r:normal /></r:navigation>}).as('')
  end
  specify '<r:navigation> without normal tag' do
    page.should render(%{<r:navigation urls="something:here"></r:navigation>}).with_error( "`navigation' tag must include a `normal' tag")
  end
  specify '<r:navigation> with urls without slashes' do
    tags = %{<r:navigation urls="Home: / | Assorted: /assorted/ | Parent: /parent/ | Radius: /radius/">
               <r:normal><r:title /></r:normal>
               <r:here><strong><r:title /></strong></r:here>
             </r:navigation>}
    expected = %{Home <strong>Assorted</strong> Parent Radius}
    page.should render(tags).as(expected)
  end
  specify '<r:navigation> with empty nodes' do
    tags = %{<r:navigation urls="Home: Boy: / | Archives: /archive/ | Radius: /radius/ | Docs: /documentation/">
               <r:normal><a href="<r:url />"><r:title /></a></r:normal>
               <r:here></r:here>
               <r:selected><strong><a href="<r:url />"><r:title /></a></strong></r:selected>
               <r:between> | </r:between>
             </r:navigation>}
    expected = %{<strong><a href="/">Home: Boy</a></strong> | <a href="/archive/">Archives</a> | <a href="/documentation/">Docs</a>}
    page(:radius).should render(tags).as(expected)
  end
  
  
  specify '<r:find>' do
    page.should render(%{<r:find url="/parent/child/"><r:title /></r:find>}).as('Child')
  end
  specify '<r:find> without url' do
    page.should render(%{<r:find />}).with_error("`find' tag must contain `url' attribute")
  end
  specify '<r:find> with nonexistant url' do
    page.should render(%{<r:find url="/asdfsdf/"><r:title /></r:find>}).as('')
  end
  specify '<r:find> with nonexistant url and file not found' do
    page.should render(%{<r:find url="/gallery/asdfsdf/"><r:title /></r:find>}).as('')
  end
  specify '<r:find> with children' do
    page.should render(%{<r:find url="/parent/"><r:children:each><r:slug /> </r:children:each></r:find>}).as('child child-2 child-3 ')
  end
  
  specify '<r:escape_html>' do
    page.should render('<r:escape_html><strong>a bold move</strong></r:escape_html>').as('&lt;strong&gt;a bold move&lt;/strong&gt;')
  end
  
  specify '<r:rfc1123_date>' do
    page(:dated).should render('<r:rfc1123_date />').as('Wed, 11 Jan 2006 00:00:00 GMT')
  end
  
  specify '<r:breadcrumbs>' do
    expected = %{<a href="/">Home</a> &gt; <a href="/parent/">Parent</a> &gt; <a href="/parent/child/">Child</a> &gt; <a href="/parent/child/grandchild/">Grandchild</a> &gt; Great Grandchild}
    page(:great_grandchild).should render('<r:breadcrumbs />').as(expected)
  end
  specify '<r:breadcrumbs> with separator attribute' do
    expected = %{<a href="/">Home</a> :: Parent}
    page(:parent).should render('<r:breadcrumbs separator=" :: " />').as(expected)
  end
  specify '<r:breadcrumbs> with nolinks attribute' do
    expected = %{Home &gt; Parent}
    page(:parent).should render('<r:breadcrumbs nolinks="true" />').as(expected)
  end
  
  specify '<r:if_url> with "matches" attribute' do
    page.should render('<r:if_url matches="a.sorted/$">true</r:if_url>').as('true')
  end
  specify '<r:if_url> with "matches" attribute that does not match' do
    page.should render('<r:if_url matches="fancypants">true</r:if_url>').as('')
  end
  specify '<r:if_url> with "matches" attribute set to a malformatted regexp' do
    page.should render('<r:if_url matches="as(sorted/$">true</r:if_url>').with_error("Malformed regular expression in `matches' argument of `if_url' tag: unmatched (: /as(sorted\\/$/")
  end
  specify '<r:if_url> without "ignore_case" attribute' do
    page.should render('<r:if_url matches="asSorted/$">true</r:if_url>').as('true')
  end
  specify '<r:if_url> with "ignore_case" attribute set to "true"' do
    page.should render('<r:if_url matches="asSorted/$" ignore_case="true">true</r:if_url>').as('true')
  end
  specify '<r:if_url> with "ignore_case" attribute set to "false"' do
    page.should render('<r:if_url matches="asSorted/$" ignore_case="false">true</r:if_url>').as('')
  end
  specify '<r:if_url> with no attributes' do
    page.should render('<r:if_url>test</r:if_url>').with_error("`if_url' tag must contain a `matches' attribute.")
  end
  
  specify '<r:unless_url> with "matches" attribute' do
    page.should render('<r:unless_url matches="a.sorted/$">true</r:unless_url>').as('')
  end
  specify '<r:unless_url> with "matches" attribute that does not match' do
    page.should render('<r:unless_url matches="fancypants">true</r:unless_url>').as('true')
  end
  specify '<r:unless_url> with "matches" attribute set to a malformatted regexp' do
    page.should render('<r:unless_url matches="as(sorted/$">true</r:unless_url>').with_error("Malformed regular expression in `matches' argument of `unless_url' tag: unmatched (: /as(sorted\\/$/")
  end
  specify '<r:unless_url> without "ignore_case" attribute' do
    page.should render('<r:unless_url matches="asSorted/$">true</r:unless_url>').as('')
  end
  specify '<r:unless_url> with "ignore_case" attribute set to "true"' do
    page.should render('<r:unless_url matches="asSorted/$" ignore_case="true">true</r:unless_url>').as('')
  end
  specify '<r:unless_url> with "ignore_case" attribute set to "false"' do
    page.should render('<r:unless_url matches="asSorted/$" ignore_case="false">true</r:unless_url>').as('true')
  end
  specify '<r:unless_url> with no attributes' do
    page.should render('<r:unless_url>test</r:unless_url>').with_error("`unless_url' tag must contain a `matches' attribute.")
  end
  
  specify '<r:cycle>' do
    page.should render('<r:cycle values="first, second" /> <r:cycle values="first, second" />').as('first second')
  end
  specify '<r:cycle> returns to beginning' do
    page.should render('<r:cycle values="first, second" /> <r:cycle values="first, second" /> <r:cycle values="first, second" />').as('first second first')
  end
  specify '<r:cycle> default name' do
    page.should render('<r:cycle values="first, second" /> <r:cycle values="first, second" name="cycle" />').as('first second')
  end
  specify '<r:cycle> keeps separate counters' do
    page.should render('<r:cycle values="first, second" /> <r:cycle values="one, two" name="numbers" /> <r:cycle values="first, second" /> <r:cycle values="one, two" name="numbers" />').as('first one second two')
  end
  specify '<r:cycle> resets counter' do
    page.should render('<r:cycle values="first, second" /> <r:cycle values="first, second" reset="true"/>').as('first first')
  end
  specify '<r:cycle> names empty' do
    page.should render('<r:cycle />').with_error("`cycle' tag must contain a `values' attribute.")
  end
  
  specify '<r:if_dev>' do
    page.should render('-<r:if_dev>dev</r:if_dev>-').as('-dev-').on('dev.site.com')
    page.should render('-<r:if_dev>dev</r:if_dev>-').as('--')
  end
  specify '<r:if_dev> on included page' do
    page.should render('-<r:find url="/devtags/"><r:content part="if_dev" /></r:find>-').as('-dev-').on('dev.site.com')
    page.should render('-<r:find url="/devtags/"><r:content part="if_dev" /></r:find>-').as('--')
  end
  
  specify '<r:unless_dev>' do
    page.should render('-<r:unless_dev>not dev</r:unless_dev>-').as('--').on('dev.site.com')
    page.should render('-<r:unless_dev>not dev</r:unless_dev>-').as('-not dev-')
  end
  specify '<r:unless_dev> on included page' do
    page.should render('-<r:find url="/devtags/"><r:content part="unless_dev" /></r:find>-').as('--').on('dev.site.com')
    page.should render('-<r:find url="/devtags/"><r:content part="unless_dev" /></r:find>-').as('-not dev-')
  end
  
  specify '<r:status>' do
    status_tag = "<r:status/>"
    status_tag_lc = "<r:status downcase='true'/>"
    page(:a).should render(status_tag).as("Published")
    page(:a).should render(status_tag_lc).as("published")
    page(:hidden).should render(status_tag).as("Hidden")
    page(:hidden).should render(status_tag_lc).as("hidden")
    page(:draft).should render(status_tag).as("Draft")
    page(:draft).should render(status_tag_lc).as("draft")
  end
  
  private
    
    def page(symbol = nil)
      if symbol.nil?
        @page ||= pages(:assorted)
      else
        @page = pages(symbol)
      end
    end
    
    def page_children_each_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:each#{attr}><r:slug /> </r:children:each>"
    end
    
    def page_children_first_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:first#{attr}><r:slug /></r:children:first>"
    end
    
    def page_children_last_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:last#{attr}><r:slug /></r:children:last>"
    end
    
    def page_eachable_children(page)
      page.children.select(&:published?).reject(&:virtual)
    end
end