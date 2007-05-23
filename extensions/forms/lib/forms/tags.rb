module Forms
  
  module Tags
    include Radiant::Taggable
    
    tag "form" do |tag|
      unless tag.attr["for"] || tag.attr["type"]
        return %{You must specify either of the "for='<model_name>'" or "type='transient'" attributes.}
      end
      
      in_context FormContext, tag do
        tag.expand.to_s
      end
    end
    
    tag "model_form" do |tag|
      in_context ModelFormContext, tag do
        tag.expand.to_s
      end
    end
    
    tag "form:text_area" do |tag|
      form_concat do
        text_area_tag(tag.attr["name"], nil, tag.attr)
      end
    end
    
    tag "form:text_field" do |tag|
      form_concat do
        text_field_tag(tag.attr["name"], nil, tag.attr)
      end
    end
    
    tag "form:submit" do |tag|
      form_concat do
        submit_tag(tag.attr)
      end
    end
    
    tag "model_form:submit" do |tag|
      form_concat do
        submit_tag(tag.attr["value"] || "Submit")
      end
    end
    
    tag "model_form:text_area" do |tag|
      form_concat do
        builder.text_area(tag.attr.delete("on"), tag.attr)
      end
    end
    
    tag "model_form:text_field" do |tag|
      form_concat do
        builder.text_field(tag.attr.delete("on"), tag.attr)
      end
    end
    
    private
      def in_context(context_type, tag, &block)
        @form_context = context_type.new(tag, controller)
        @form_context.do_form_with(&block)
        @form_context._erbout
      end
      
      def form_concat(&block)
        @form_context._erbout << @form_context.instance_eval(&block)
      end
  end
  
  class FormContext
    include ERB::Util
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::CaptureHelper
    
    attr_reader :_erbout, :action_path, :controller, :page_url, :model
    
    def initialize(tag, controller)
      @tag = tag
      @model, @type = tag.attr["for"], tag.attr["type"]
      @action_path = tag.attr["action"] || "/forms/"
      @page_url = tag.locals.page.url
      @controller = controller
      @_erbout = ""
    end
    
    def concat_memento
      _erbout << hidden_field_tag("form_memento", "#{type}:#{model}:#{page_url}")
    end
    
    def do_form_with(&block)
      form_tag(action_path) do
        concat_memento
        instance_eval(&block)
      end
    end
    
    def type; @type || "meta"; end
  end
  
  class ModelFormContext < FormContext
    attr_reader :builder
    
    def do_form_with(&block)
      form_for model, :url => action_path do |f|
        @builder = f
        concat_memento
        instance_eval(&block)
      end
    end
    
    def type; @type || "model"; end
  end
  
end