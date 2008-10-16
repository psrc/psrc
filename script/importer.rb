
require 'rubygems'
require 'hpricot'
require 'mechanize'
require 'sha1'
require 'config/environment'
require 'tidy'

Tidy.path = "/usr/lib/libtidy.so"
HOME = "http://localhost:3001/import/psrctest.cevian.net/"

def reload_db
  `psql psrc_dev < db/pages/pages.sql`
end

reload_db

def follow_link link
  return if link.href.nil? or link.href =~ /#/ or link.href =~ /\Amailto/ or link.href !~ /\.htm/ or link.href =~ /\Ajavascript/ or link.href =~ /http:/ or link.href =~ /httm:/
  $pages ||= []
  return if $agent.visited?(link) 
  page = $agent.click link rescue Net::HTTPNotFound nil
  puts "Saving #{ page.uri.to_s }"
  $pages << page
  return if page.class == WWW::Mechanize::File
  page.links.each { |l| follow_link l }
end

def fix_text text
  Iconv.conv("UTF-8", "ISO-8859-1", text)
end

def fix_body body
  body = (Hpricot(body) / '#mainContent')
  ( body / 'script' ).remove
  ( body / 'h1' ).remove
  php_links = ( body / 'a').select { |l| l.attributes["href"] =~ /\.php\.html/ }.each { |l| l.raw_attributes["href"] = remove_php(l.attributes["href"]) }
  body = body.inner_html
  body = Tidy.new(:hide_comments => true, :wrap => 0, :ident_spaces => 4, :break_before_br => true, :drop_font_tags => true, :indent => true, :show_body_only => true).clean(body)
  fix_text body
end

def page_title page
  title = (Hpricot(page.body) / 'h1').inner_html
  title = (Hpricot(page.body) / 'h2').inner_html if title.empty?
  title = page.title if title.empty?
  title = fix_text title
  title = Hpricot(title).to_plain_text
  puts "Title is #{ title }"
  title
end

def path_for uri
  m = uri.to_s.match("psrctest.cevian.net/(.+)")
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
      Page.create!(:parent => create_parent_if_needed_for(directory), :title => slug, :breadcrumb => slug, :slug => slug.gsub(/[^A-Za-z0-9]/, '-'), :status_id => 100, :layout_id => 5)
    rescue ActiveRecord::RecordInvalid
      nil
    end
  end
end

def remove_php link
  link = link.gsub(/\.php\.html/, '')
  link.gsub(/\.php/, '')
end

$agent = WWW::Mechanize.new
front_page = $agent.get(HOME)
links = front_page.links
links.each_with_index do |l, i|
  follow_link l
end

$pages.sort! { |a, b| a.uri.to_s <=> b.uri.to_s }

$home_page = Page.root

$pages.each do |page|
    puts " *** processing " + path_for(page.uri)
    parent = create_parent_if_needed_for(page.uri)
    if page.uri.to_s =~ /index\./
      puts "Setting page to parent page"
      radiant_page = parent
    end
    radiant_page ||= Page.new :title => page_title(page), :parent => parent, :breadcrumb => page_title(page), :slug => remove_php(File.basename(page.uri.to_s)), :status_id => 100, :layout_id => 2
    radiant_page.title = page_title page
    radiant_page.breadcrumb = page_title page
    radiant_page.parts << PagePart.new(:name => "body", :content => fix_body(page.body))  unless radiant_page.parts.find_by_name("body")
    radiant_page.save
    puts " >> Created #{ radiant_page.url }!"
    puts radiant_page.errors.full_messages unless radiant_page.valid?
end
