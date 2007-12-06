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
    create_page "Assorted" do
      breadcrumbs = %w(f e d c b a j i h g)
      %w(a b c d e f g h i j).each_with_index do |name, i|
        create_page name, :breadcrumb => breadcrumbs[i], :published_at => Time.now - (10 - i).minutes
      end
      create_page "assorted_draft", :status_id => Status[:draft].id, :slug => "draft"
    end
    create_page "Draft", :status_id => Status[:draft].id
    create_page "Hidden", :status_id => Status[:hidden].id
    date = Time.utc(2006, 1, 11)
    create_page "Dated", :published_at => date, :created_at => (date - 1.day), :updated_at => (date + 1.day)
    create_page "Childless"
  end
  
end