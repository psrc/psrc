require_dependency "models/page"

class Page

  private

    DEFAULT_PARTS = Radiant::Config['default.parts'].split(',').collect { |part_name| part_name.strip }

    # Strip HTML tags before creating the index on default page parts.
    # This method does not validate the HTML structure.
    # Partial and/or broken tags may result in stripping more than expected.

    DEFAULT_PARTS.each do |part|

      define_method(part) do
        html = behavior.render_page_part(part)
        html.gsub(/<\/?[^>]+>/,'')
      end

    end

    acts_as_ferret :fields => [ 'title' ] + DEFAULT_PARTS

end
