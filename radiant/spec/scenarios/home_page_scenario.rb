class HomePageScenario < Scenario::Base
  
  def load
    create_page "Home", {
      :slug => "/",
      :parent_id => nil
    }
  end
  
  helpers do
    def create_page(name, attributes={})
      attributes = page_params(attributes.reverse_merge(:title => name))
      body = attributes.delete(:body)
      symbol = name.symbolize
      create_record :page, symbol, attributes
      @last_page_created_id = page_id(symbol)
      create_page_part "#{name} Body", :name => "body", :content => body
    end
    def page_params(attributes={})
      title = attributes[:title] || unique_page_title
      attributes = {
        :title => title,
        :slug => title.symbolize,
        :class_name => nil,
        :status_id => Status[:published].id,
        :published_at => Time.now.to_s(:db)
      }.update(attributes)
      attributes[:parent_id] = page_id(:home) unless attributes.has_key?(:parent_id)
      attributes
    end
    
    def create_page_part(name, attributes={})
      create_record :page_part, name.symbolize, page_part_params(attributes)
    end
    def page_part_params(attributes={})
      name = attributes[:name] || "unnamed"
      attributes = {
        :name => name,
        :content => name,
        :page_id => @last_page_created_id
      }.update(attributes)
    end
    
    private
      @@unique_page_title_call_count = 0
      def unique_page_title
        @@unique_page_title_call_count += 1
        "Page #{@@unique_page_title_call_count}"
      end
  end
end