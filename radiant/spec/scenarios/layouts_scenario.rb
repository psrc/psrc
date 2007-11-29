class LayoutsScenario < Scenario::Base
  
  def load
    create_layout "Home Page", {
      :content => <<-CONTENT
<html>
  <head>
    <title><r:title /></title>
  </head>
  <body>
    <r:content />
  </body>
</html>
      CONTENT
    }
    
    create_layout "UTF-8 Layout", {
      :content => <<-CONTENT
<html>
  <head>
    <title><r:title /></title>
  </head>
  <body>
    <r:content />
  </body>
</html>
      CONTENT
    }
  end
  
  helpers do
    
    def create_layout(name, attributes={})
      create_record :layout, name.symbolize, layout_params(attributes.reverse_merge(:name => name))
    end
    def layout_params(attributes)
      name = attributes[:name] || unique_layout_name
      { 
        :name => name,
        :content => "<r:content />"
      }.merge(attributes)
    end
    
    private
    
      @@unique_layout_name_call_count = 0
      def unique_layout_name
        @@unique_page_title_call_count += 1
        "Layout #{@@unique_page_title_call_count}"
      end
    
  end
end