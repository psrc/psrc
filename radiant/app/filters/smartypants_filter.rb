require 'rubypants/rubypants'

class SmartyPantsFilter < TextFilter::Base
  register 'SmartyPants'

  def filter(text)
    RubyPants.new(text).to_html
  end
end
