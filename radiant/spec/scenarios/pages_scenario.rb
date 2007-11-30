class PagesScenario < Scenario::Base
  uses :home_page
  
  def load
    create_page "First"
    create_page "Another"
    create_page "Radius", :body => "<r:title />"
    create_page "Parent" do
      create_page "Child" do
        create_page "Grandchild" do
          create_page "Great Grandchild"
        end
      end
      create_page "Child 2"
      create_page "Child 3"
    end
    create_page "Draft", :status_id => Status[:draft].id
  end
  
end