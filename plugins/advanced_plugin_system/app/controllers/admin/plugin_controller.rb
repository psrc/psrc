class Admin::PluginController < ApplicationController
  
  only_allow_access_to :index, :when => :admin,
    :denied_url => {:controller => 'page', :action => :index},
    :denied_message => 'You must have administrative privileges to perform this action.'
    
  def index
    @plugins = Plugin.registered.values
  end
  
end