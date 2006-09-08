require 'bluecloth'
require 'rubypants/rubypants'

class MarkdownFilter < TextFilter::Base
  register 'Markdown'

  def filter(text)
    RubyPants.new(BlueCloth.new(text).to_html).to_html
  end
end
