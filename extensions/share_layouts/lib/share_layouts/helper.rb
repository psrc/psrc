module ShareLayouts::Helper
  class TransactionBreak < StandardError; end
  
  def radiant_layout(name = @radiant_layout)
    returning String.new do |output|
      begin
        ShareLayouts::RailsPage.transaction do 
          page = ShareLayouts::RailsPage.new(:class_name => "ShareLayouts::RailsPage")
          assign_attributes!(page, name)
          page.build_parts_from_hash!(extract_captures)
          page.save! 
          output << page.render
          raise TransactionBreak, "don't save!"
        end
      rescue TransactionBreak
      rescue 
        raise
      end
    end
  end
  
  def assign_attributes!(page, name = @radiant_layout)
    page._layout = Layout.find_by_name(name)
    page.title = @title || @content_for_title || ''
    page.breadcrumbs = @breadcrumbs || @content_for_breadcrumbs || ''
    page.request_uri = request.request_uri
  end
    
  def extract_captures
    variables = instance_variables.grep(/@content_for_/)
    variables.inject({}) do |h, var|
      var =~ /^@content_for_(.*)$/
      key = $1.intern
      key = :body if key == :layout
      unless key == :title || key == :breadcrumbs
        h[key] = instance_variable_get(var)
      end
      h
    end
  end
end
