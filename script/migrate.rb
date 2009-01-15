#!/usr/bin/env ruby

require 'config/environment'

PagePart.connection.transaction do
  PagePart.find(:all).each do |part|
    part.filter_id = "WymEditor"
    part.content = RedCloth.new(part.content).to_html
    part.save!
  end
end
