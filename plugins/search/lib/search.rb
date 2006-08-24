require_dependency 'models/behavior'

class Search < Behavior::Base
  
  register 'Search'
  
  LOGGER = ActionController::Base.logger
  
  description %{
    The Search behavior adds search capabilities to a Radiant site. The search
    engine builds an index that is updated each time you clear the cache.

    = Query Constructs

    == Simple Query
    
      A simple search consists of a single word:
    
      Example:

        house
        tree

    A basic query is what the other queries are built upon.

    == Boolean

      You may specify which terms are required or optional for your results.

      Example:

        house OR tree
        house NOT tree

    == Wild Cards

      A wild query is a query using the pattern matching characters * and ?.

      Example:

        hous*
        house? OR tree

    == Fuzzy Query

      If you are not sure how to spell the search term you may use fuzzy queries.

      Example:

        huose~

    == Phrases
      
      A phrase query is a string of terms surrounded by double quotes.

      Example:

        "big house"

      The example matches "big house". Alternatively we could set the "slop"
      for the phrase which allows a certain variation in the match of the phrase.
      The slop for a phrase is an integer indicating how many positions you are
      allowed to move the terms to get a match.
      
      Example:

        "big house"~2

      This would match "big house", "big red house", "big red brick house" and even "house big".

    == Field Selection

      You may query only specific page parts by using the <field>[|<field>|...]: syntax.
      
      Example:
      
        title: sear* term
        title|body: NOT search term

    = Setup

    == Configuration
      
      You have the option of configuring the behavior via a page part labeled "config".
      The configuration describes which page parts will be searched by default. If you
      choose to let the Search behavior figure out the best configuration it will search
      through all default.parts as specified in the config database table.

      Example:

        fields: [title, body]

    == Enable Search Behavior

      Using the "Search" behavior it is possible to provide standard form-based search
      as well as "live" search functionality. In order to enable "live" search you must
      create an additional page part called "update" that renders the search result.
      Assume a page with slug "search" as a child of the root page. The "body" page part
      of this page may look like:

      <r:search:form />
      <hr />
      <r:search:empty>
        No match.
      </r:search:empty>
      <r:search:results>
        Results:
        <ul>
          <r:search:results:each>
            <li>
              <r:link/> by <r:author/>
            </li>
          </r:search:results:each>
        </ul>
      </r:search:results>
      
      To extend this example to allow a "live" search from the header
      snippet that is included into every page, (Typo style live search),
      you need to create a page part called "update" which is only rendered
      when search results are returned from a "live" search request.
      Additionally, there is a new tag <r:search:update /> that lets you
      position the "update" element (it will contain the search results).

      <ul>
        <r:search:results:each>
          <li><r:link/></li>
        </r:search:results:each>
      </ul>

      The "form" page part is included into the header snippet, described
      below:

      <r:search:form update="search-results" prototype="true" 
                     label="Live search:" />
      <r:search:update />

      Since, the header snippet itself is not always rendered in the
      context of a "Search" behavior the <r:search:form> tag is not always
      available. This prevents us from adding the form directly into the
      header snippet and requires the creation of the "form" page part for
      the search page. This page part can be easily included into the
      header snippet with the following lines:
      
      <r:find url="/search">
        <r:content part="update"/>
      </r:find>
      
  }


  define_tags do

    #
    # <r:search/>
    #
    tag 'search' do |tag|
      tag.expand
    end

    #
    # <r:search:form [label="Search term:"] [update="element-to-update]
    #                [prototype="true"]/>
    #
    #   Generates a simple search form that submits its content to the
    #   search page for which it was created. Additional attributes are
    #   optional:
    #
    #     label:     
    #       Defines an alternative label for the search field, the default
    #       is "Search:".
    #
    #     update:  
    #       Enables the form observer for live search and specifies the ID
    #       of the HTML element that is updated with the results.
    #
    #     prototype: 
    #       If its value is "true" the Prototype JavaScript library shipped
    #       with Radiant is explicitly loaded, but only if the live search
    #       is enabled.
    #
    tag 'search:form' do |tag|
      # TODO: must ensure the tag search:form:update has the same tag.attr['update'] value
      tag.attr.update(form_configuration)

      # TODO: expand tag, but have flexibility to have a stand-alone search:form:update tag
      render_to_string(:partial => "search/form", :locals => { :tag => tag, :page => page })
    end

    #
    # <r:search:update/>
    #
    #   This tag will contain the rendered output of the "update" page part.
    #
    tag 'search:update' do |tag|
      # TODO: tag attributes must inherit from search:form
      tag.attr.update(form_configuration)
 
      if update_element?
        render_to_string(:partial => 'search/update', :locals => { :tag => tag, :page => page })
      else
        "`search:form:update' tag is used without having an `update' page part"
      end
    end

    #
    # <r:search:query/>
    #
    #   The original search query string.
    # 
    tag 'search:query' do |tag|
      query
    end
    
    #
    # <r:search:empty> [content] </r:search:empty>
    #
    #   Render [content] only if the result set is empty 
    #   (e.g. "No match").
    #
    tag 'search:empty' do |tag|
      if query_result.empty?
        tag.expand
      end
    end
    
    #
    # <r:search:results> [content] </r:search:results>
    #    
    #   Renders [content] only if the result set is not empty.
    #
    tag 'search:results' do |tag|
      if not query_result.empty?
        tag.expand
      end
    end

    #
    # <r:search:results:each> [content] </r:search:results:each>
    #
    #   Renders [content] for every page in the result set. Within this tag
    #   default tags to access page attributes (i.e. <r:url/>, <r:link/>,
    #   r:title/>, <r:author/>, etc.) are valid and defined for the
    #   currently processed page from the result set.
    # 
    tag 'search:results:each' do |tag|
      content = ''
      query_result.each { |result|
        tag.locals.page = result
        content << tag.expand
      }
      content
    end

  end

  protected

    def render_page
      set_query(request.parameters)
      LOGGER.debug("query: #{query.inspect}")
      if not query.empty?
        set_query_result
        LOGGER.debug("query result: #{query_result.inspect}")
      end
      if update_element?
        render_page_part(:update)
      else
        super
      end
    end

    def cache_page?
      false
    end

  private

    def update_element?
      not page.parts.reject { |part| part.name != "update" }.empty?
    end

    def query
      @query ||= Query.new
    end

    def set_query(options)
      options.update(page_config)
      @query = Query.new(options)
    end

    alias_method :set_default_query, :query

    def query_result
      @query_result ||= []
    end

    alias_method :set_default_query_result, :query_result

    def set_query_result
      pages = Page.find_by_contents(query)
      @query_result = pages.delete_if { |p| !p.published? }
    rescue Ferret::QueryParser::QueryParseException
      set_default_query_result
    end

    def form_configuration 
      { 'id'        => 'search-form',
        'label'     => 'Search',
        'update'    => update_element? ? 'search-results' : '',
        'prototype' => 'true' }
    end
end
