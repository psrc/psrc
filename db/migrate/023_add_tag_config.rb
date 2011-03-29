class AddTagConfig < ActiveRecord::Migration
  def self.up
    Radiant::Config['tags.results_page_url'] = '/tagged'
    [ "Urban centers", "Transit-oriented development", "Expensive housing markets", "Innovative single-family techniques", "Education and outreach",
      "Single-family", "Multifamily", "Ownership", "Rental", "Market rate", "Subsidized", "Density/diversity",
      "80-120% AMI", "Less than 80%", "Less than 50%", "Most likely to produce less than 80% AMI" ].each do |tag|
        MetaTag.find_or_create_by_name(tag)
      end
      
    (p = TagSearchPage.find_or_initialize_by_slug('housing-toolkit-search')).update_attributes(:title => "Housing Toolkit Search", :slug => "housing-toolkit-search", :breadcrumb => "Housing Toolkit Search", :class_name => "TagSearchPage", :status_id => 100, :parent_id => 1, :layout_id => nil, :created_at => "2011-03-29 10 =>22 =>00", :updated_at => "2011-03-29 17 =>54 =>29", :published_at => "2011-03-29 10 =>30 =>53", :created_by_id => 29, :updated_by_id => 29, :virtual => false, :lock_version => 7, :description => "", :keywords => "", :show_banner => true, :sitemap => true, :change_frequency => "weekly", :priority => "0.5")
    if p.parts.empty?
      content = <<-EOB
<form action="" method="get">
  <h2>FOCUS AREA</h2>
  <select name="tag[]">
    <r:search:options options="Urban centers; Transit-oriented development; Expensive housing markets; Innovative single-family techniques; Education and outreach" />
  </select>

  <h2>PROJECT TYPE</h2>
  <select name="tag[]">
    <r:search:options options="Single-family; Multifamily; Ownership; Rental; Market rate; Subsidized; Density/diversity"/>
  </select>

  <h2>AFFORDABILITY</h2>
  <select name="tag[]">
    <r:search:options options="80-120% AMI; Less than 80%; Less than 50%; Most likely to produce less than 80% AMI" />
  </select>

  <p><input type="submit" value="Search"></p>
</form>

<r:search:query_present>
  <r:search:empty>
    <h2>No pages found tagged with "<r:search:query/>".</h2>
  </r:search:empty>

  <r:search:results>
    <h2>Found the following pages that are tagged with "<em><r:search:query/></em>".</h2>

    <ul>
    <r:search:results:each>
      <li><r:link/> - <r:author/> - <r:date/></li>
    </r:search:results:each>
    </ul>
  </r:search:results>
</r:search:query_present>
EOB
      p.parts.create(:name => 'body', :content => content)
      %w(col2 col3 summary).each do |name|
        p.parts.create(:name => name, :filter_id => 'Textile')
      end
    end
  end
  
  def self.down
    
  end
end