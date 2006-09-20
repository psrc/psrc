require 'application_helper'

module ApplicationHelper
  def links_for_navigation
    tabs = Plugin::Base.admin.tabs
    links = tabs.map do |tab|
      nav_link_to(tab.name, tab.url) if tab.shown_for?(session[:user])
    end.compact
    links.join(separator)
  end
end