module Admin::EventsHelper
  include Admin::NodeHelper

  # Looks at the layouts in the layouts directory and returns an array of arrays
  # suitable for the select tag popuplated with the layout file names.
  def options_for_layouts
    extract_name = Proc.new { |layout| File.basename(layout, '.html.haml') }
    Dir["vendor/extensions/event_registrations/app/views/layouts/*"].map do |layout|
      [extract_name.call(layout).humanize, extract_name.call(layout)]
    end
  end

end
