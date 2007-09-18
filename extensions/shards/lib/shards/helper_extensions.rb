module Shards::HelperExtensions
  def render_region(region)
    @controller_name ||= @controller.controller_name
    @template_name ||= File.basename(@first_render).split(".").last
    admin.send(@controller_name).send(@template_name)[region].compact.map do |partial|
      render :partial => partial
    end.join
  end
end
