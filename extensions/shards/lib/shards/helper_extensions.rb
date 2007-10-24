module Shards::HelperExtensions
  def render_region(region, options={})
    @controller_name ||= @controller.controller_name
    @template_name ||= File.basename(@first_render).split(".").last
    admin.send(@controller_name).send(@template_name)[region].compact.map do |partial|
      render options.merge(:partial => partial)
    end.join
  end
end
