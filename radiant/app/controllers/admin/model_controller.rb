class Admin::AbstractModelController < ApplicationController
  def self.model(*symbols)
    first = symbols.first
    class_eval %{
      @@model_class = "#{first}".singularize.camelize.constantize
    }
    super
  end

  def index
    self.models = model_class.find(:all)
  end

  def new
    self.model = model_class.new
    handle_new_or_edit_post
  end
  
  def edit
    self.model = model_class.find_by_id(params[:id])
    render :template => "admin/#{ model_symbol }/new" if handle_new_or_edit_post
  end
  
  def remove
    self.model = model_class.find(params[:id])
    if request.post?
      model.destroy
      announce_removed
      redirect_to model_index_url
    end
  end
  
  protected
  
    def model_class
      self.class.class_eval %{ @@model_class }
    end
    
    def model
      instance_variable_get("@#{model_symbol}")
    end
    def models
      instance_variable_get("@#{plural_model_symbol}")
    end
    
    def model=(object)
      instance_variable_set("@#{model_symbol}", object)
    end
    def models=(objects)
      instance_variable_set("@#{plural_model_symbol}", objects)
    end
    
    def model_name
      model_class.name
    end
    def plural_model_name
      model_name.pluralize
    end
    
    def model_symbol
      model_name.underscore.intern
    end
    def plural_model_symbol
      model_name.pluralize.underscore.intern
    end
    
    def humanized_model_name
      model_name.underscore.humanize
    end
    
    def model_index_url
      send("#{ model_symbol }_index_url")
    end
    
    def announce_saved(message = nil)
      flash[:notice] = message || "#{humanized_model_name} saved below."
    end
    
    def announce_validation_errors
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
    end
    
    def announce_removed
      flash[:notice] = "#{humanized_model_name} has been deleted."
    end
    
    def handle_new_or_edit_post(options = {})
      opitons = options.symbolize_keys!
      if request.post?
        model.attributes = params[model_symbol]
        if model.save
          announce_saved(options[:saved_message])
          redirect_to options[:redirect_to] || model_index_url
          return false
        else
          announce_validation_errors
        end
      end
      true
    end
end