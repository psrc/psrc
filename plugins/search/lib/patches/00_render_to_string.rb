# Include Behavior::View in a controller to make render_to_string() a public method.
# This module allows behaviors to seperate views from program logic. 

module Behavior
  module View

    def render_to_string(options = nil, &block)
      erase_render_results
      super
    end
 
  end
end
