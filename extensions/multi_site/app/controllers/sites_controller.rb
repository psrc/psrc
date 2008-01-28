class SitesController < ApplicationController
  # A hack, but the only way it works in something other than dev mode
  write_inheritable_attribute :resourceful_callbacks, {}
  write_inheritable_attribute :resourceful_responses, {}
  write_inheritable_attribute :parents,               []
  
  make_resourceful do
    actions :index, :new, :create, :edit, :update, :destroy
    
    response_for :create, :update, :destroy do |format|
      format.html { redirect_to objects_path }
    end
  end
  
  %w{move_higher move_lower move_to_top move_to_bottom}.each do |action|
    define_method action do
      load_object
      current_object.send(action)
      respond_to do |format|
        format.html { redirect_to objects_path }
        format.js do  
          id = "#{current_model_name.underscore}_#{current_object.id}"
          render :update do |page|
            page[id].__send__(action)
            page.visual_effect(:highlight, id)
          end
        end 
      end
    end
  end
end
