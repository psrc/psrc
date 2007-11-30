class VirtualPage < Page
  def virtual?
    true
  end
end

class VirtualPageScenario < Scenario::Base
  uses :home_page
  
  def load
    create_page "Virtual", :class_name => "VirtualPage"
  end
  
end