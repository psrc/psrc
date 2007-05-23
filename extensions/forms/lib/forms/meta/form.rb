module Forms
  module Meta
    
    # This is what an administrator would create in the UI, so that designers could
    # have forms to place anywhere they'd like. It specifies what fields are available,
    # and those fields define their requirements and type. Actions are attached to
    # meta forms, which will be invoked whenever a meta form is submitted from the
    # public site of a Radiant app.
    #
    # It is quite fine for extension developers to pre-define some of these. Note that
    # they will still be shown in the administrative UI.
    class Form < ActiveRecord::Base
      set_table_name "meta_forms"
      
      has_many :fields, :class_name => "Forms::Meta::Field"
    end
    
  end
end