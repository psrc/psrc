require_dependency 'admin/model_controller'

class Admin::LayoutController < Admin::AbstractModelController
  model :layout
  
  only_allow_access_to :index, :new, :edit, :remove,
    :when => [:developer, :admin],
    :denied_url => { :controller => 'page', :action => 'index' },
    :denied_message => 'You must have developer privileges to perform this action.'

end