class HelloTagExtension < Radiant::Extension
  version "1.0"
  description "This extension adds the <r:hello /> tag."
  url "http://dev.radiantcms.org/radiant/browser/trunk/extensions/examples/hello_tag/"
  
  def activate
    # The reference to HelloTag causes it to be automatically loaded
    # from lib/hello_tag.rb
    Page.send :include, HelloTag
  end
end