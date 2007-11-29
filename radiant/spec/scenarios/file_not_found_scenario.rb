class FileNotFoundScenario < Scenario::Base
  uses :home_page
  
  def load
    create_page "File Not Found", {
      :slug => "missing",
      :class_name => "FileNotFoundPage",
    }
  end
end