module Behavior

  class Base

    class << self
      def set_controller(controller)
        @@controller = controller
      end
    end

    def render_to_string(options = nil, &block)
      @@controller.render_to_string(options, &block)
    end

  end

end
