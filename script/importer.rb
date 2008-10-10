
require 'rubygems'
require 'hpricot'
require 'mechanize'
require 'sha1'
require 'config/environment'
require 'tidy'

Tidy.path = "/usr/lib/libtidy.so"
HOME = "http://localhost:3001/import/www.psrc.org/"

def reload_db
  `psql psrc_dev < db/pages/pages.sql`
end

reload_db

def follow_link link
  $pages ||= []
  #return if $pages.size > 50
  return if link.href.nil? or link.href =~ /\A#/ or link.href =~ /\Amailto/ or link.href =~ /\Ajavascript/ or link.href !~ /\.htm?\Z/ or link.href =~ /http:/ or link.href =~ /httm:/
  return if $agent.visited?(link)
  page = $agent.click link rescue Net::HTTPNotFound nil
  puts "Saving #{ page.uri.to_s }"
  $pages << page
  return if page.class == WWW::Mechanize::File
  page.links.each { |l| follow_link l }
end

def fix_body body
  body = (Hpricot(body) / 'body')
  ( body / 'script' ).remove
  body = body.inner_html
  body = Tidy.new(:hide_comments => true, :wrap => 0, :ident_spaces => 4, :break_before_br => true, :drop_font_tags => true, :indent => true, :show_body_only => true).clean(body)
  Iconv.conv("UTF-8", "ISO-8859-1", body)
end

def path_for uri
  m = uri.to_s.match("www.psrc.org/(.+)")
  if m
    m[1]
  else
    uri
  end
end

def create_parent_if_needed_for(uri)
  p = Page.find_by_url(File.dirname(path_for(uri)))
  if p and p.class != FileNotFoundPage
    puts "found #{p.url}!"
    return p
  else
    directory = File.dirname(path_for(uri))
    slug = directory.split("/").last
    if slug == "."
      return $home_page
    end
    puts "didn't find page for #{ directory }, creating"
    puts "slug is #{ slug }"
    begin
      Page.create!(:parent => create_parent_if_needed_for(directory), :title => slug, :breadcrumb => slug, :slug => slug.gsub(/[^A-Za-z0-9]/, '-'), :status_id => 100) 
    rescue ActiveRecord::RecordInvalid
      nil
    end
  end
end

$agent = WWW::Mechanize.new
front_page = $agent.get(HOME)
links = front_page.links
links.each_with_index do |l, i|
  follow_link l
end

$pages.sort! { |a, b| a.uri.to_s <=> b.uri.to_s }

#$home_page = Page.create! :parent_id => 1, :title => "Imported data", :breadcrumb => "Imported Data", :slug => "imports", :status_id => 100, :layout_id => 7
$home_page = Page.find 1
$pages.each do |page|
    puts " *** processing " + path_for(page.uri)
    parent = create_parent_if_needed_for(page.uri)
    if page.uri.to_s =~ /index\.htm\Z/
      puts "Setting page to parent page"
      radiant_page = parent
    end
    radiant_page ||= Page.new :title => page.title, :parent => parent, :breadcrumb => page.title, :slug => File.basename(page.uri.to_s), :status_id => 100, :layout_id => 5
    radiant_page.parts << PagePart.new(:name => "body", :content => fix_body(page.body))
    radiant_page.save
    puts " >> Created #{ radiant_page.url }!"
    puts radiant_page.errors.full_messages unless radiant_page.valid?
end

