module ApplicationHelper
  include LocalTime
  include Admin::RegionsHelper
  include EventsHelper
  
  # Fixie Added Helpers - Not sure where to put these yet #

  # YUI Grids
  def grid style, options={}, &block
    yui_grid = case style
      when :thirds : 'yui-gb'
      when :two_thirds : 'yui-gc'
      when :one_third : 'yui-gd'
      when :three_fourths : 'yui-ge'
      when :one_fourth  : 'yui-gf'
      when :halves : 'yui-g'
    end

    haml_tag :div, {:id => options[:id], :class => "#{yui_grid} #{"first" if options[:first]}"} do
      block.call
    end
  end

  def grid_unit options={}, &block
    haml_tag :div, {:id => options[:id], :class => "yui-u#{ ' first' if options[:first] }"} do
      block.call
    end
  end
  
  def sidebar &block
    @sidebar = true
    haml_tag :div, {:id => "sidebar", :class => "yui-b"} do
      block.call
    end
  end
  
  def main_content &block
    haml_tag :div, {:id => "yui-main"} do
      haml_tag :div, {:id => "main-content-wrapper", :class => "#{"yui-b" if @sidebar }"} do
        block.call
      end
    end
  end

  def document options={}, &block
    haml_tag :div, {:id => "custom-doc", :class => "#{ 'yui-t2' if options[:sidebar] }"} do
      haml_tag :div, {:id => "bd"} do
        block.call
      end
    end
  end

  def page_id
    "#{controller.controller_name}_#{controller.action_name}"
  end

  def page_class
    controller.controller_name
  end

  def section title, options={}, &block
    haml_tag :div, {:id => options[:id], :class => "section"} do

      haml_tag((options[:header_size] || :h3), title)
      haml_tag :div, {:class => "section-content"} do
        block.call
      end
    end
  end

  # Common code to display errors from flash/object errors
  def flash_messages(object_name=nil, options = {})
    if flash[:error].is_a?(Array)
      style = 'error'
      msgs = error_box(flash[:error])

    elsif flash[:error]
      style = 'error'
      msgs = flash[:error]

    elsif flash[:notice]
      style = 'notice'
      msgs = flash[:notice]

    elsif flash[:success]
      style = 'success'
      msgs = flash[:success]

    elsif object_name
      style = 'error'
      options = options.symbolize_keys
      object = instance_variable_get("@#{object_name}")
      if object && !object.errors.empty?
        msgs = error_box(object.errors.full_messages)
      end
    end

    %Q{<div id="message_box" class="#{style}">#{msgs}</div>} if msgs
  end

  def logo
    "<div id='logo'>#{ link_to image_tag("gg_logo_small.gif", :alt => "GroupieGuide"), new_group_path }</div>"
  end

  def back_to_group_path(group)
    "<div class='header-action'>#{ link_to "&laquo; Back to #{ group.name }" , group_host_path(group)}</div>"
  end

  # Message to display to user
  def error_box(messages)
    %{<img src="/images/icons/error.gif" alt="Error" class="vtop" />
       <strong>The following problems were encountered:</strong>
       <ol id="err_msgs">#{messages.collect {|msg| content_tag("li", msg) }}</ol>
       <div id="err_fix">Please correct the above issues and try again.</div>}
  end

  # calculate range of current items in paginator
  def pagination_range(collection)
    first = (collection.current_page - 1) * collection.per_page + 1
    last  = first + (collection.per_page - 1)
    last  = last > collection.total_entries ? collection.total_entries : last

    collection.total_entries > 0 ? "#{first} - #{last}" : "0"
  end

  # http://daniel.collectiveidea.com/blog/2007/7/10/a-prettier-truncate-helper
  def word_truncate(text, length = 30, strip_html_tags = true, truncate_string = "...")
    return if text.nil?
    l = length - truncate_string.chars.length
    if text.chars.length > length
      something = text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m]
      something ||= "" # in case the above regex returns nil, can if input is all symbols or something, see my comment on that page
      result = something + truncate_string
    else
      result = text
    end
    if strip_html_tags
      strip_tags(result)
    else
      result
    end
  end

  # End Fixie Helpers #

  def config
    Radiant::Config
  end
  
  def default_page_title
    title + ' - ' + subtitle
  end
  
  def title
    config['admin.title'] || 'Radiant CMS'
  end
  
  def subtitle
    config['admin.subtitle'] || 'Publishing for Small Teams'
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def save_model_button(model)
    label = if model.new_record?
      "Create #{model.class.name}"
    else
      'Save Changes'
    end
    submit_tag label, :class => 'button'
  end
  
  def save_model_and_continue_editing_button(model)
    submit_tag 'Save and Continue Editing', :name => 'continue', :class => 'button'
  end
  
  # Redefine pluralize() so that it doesn't put the count at the beginning of
  # the string.
  def pluralize(count, singular, plural = nil)
    if count == 1
      singular
    elsif plural
      plural
    else
      Inflector.pluralize(singular)
    end
  end
  
  def links_for_navigation
    tabs = admin.tabs
    links = tabs.map do |tab|
      nav_link_to(tab.name, File.join(request.relative_url_root, tab.url)) if tab.shown_for?(current_user)
    end.compact
    links.join(separator)
  end
  
  def separator
    %{ <span class="separator"> | </span> }
  end
  
  def current_url?(options)
    url = case options
    when Hash
      url_for options
    else
      options.to_s
    end
    request.request_uri =~ Regexp.new('^' + Regexp.quote(clean(url)))
  end
  
  def clean(url)
    uri = URI.parse(url)
    uri.path.gsub(%r{/+}, '/').gsub(%r{/$}, '')
  end
  
  def nav_link_to(name, options)
    if current_url?(options)
      %{<strong>#{ link_to name, options }</strong>}
    else
      link_to name, options
    end
  end
  
  def admin?
    current_user and current_user.admin?
  end
  
  def developer?
    current_user and (current_user.developer? or current_user.admin?)
  end
  
  def focus(field_name)
    javascript_tag "Field.activate('#{field_name}');"
  end
  
  def updated_stamp(model)
    unless model.new_record?
      updated_by = (model.updated_by || model.created_by)
      login = updated_by ? updated_by.login : nil
      time = (model.updated_at || model.created_at)
      if login or time
        html = %{<p style="clear: left"><small>Last updated } 
        html << %{by #{login} } if login
        html << %{at #{ timestamp(time) }} if time
        html << %{</small></p>}
        html
      end
    else
      %{<p class="clear">&nbsp;</p>}
    end
  end

  def timestamp(time)
    adjust_time(time).strftime("%I:%M <small>%p</small> on %B %d, %Y")     
  end 
  
  def meta_visible(symbol)
    v = case symbol
    when :meta_more
      not meta_errors?
    when :meta, :meta_less
      meta_errors?
    end
    v ? {} : {:style => "display:none"}
  end
  
  def meta_errors?
    false
  end
  
  def toggle_javascript_for(id)
    "Element.toggle('#{id}'); Element.toggle('more-#{id}'); Element.toggle('less-#{id}');"
  end
  
  def image(name, options = {})
    image_tag(append_image_extension("admin/#{name}"), options)
  end
  
  def image_submit(name, options = {})
    image_submit_tag(append_image_extension("admin/#{name}"), options)
  end
  
  def admin
    Radiant::AdminUI.instance
  end
  
  private
  
    def append_image_extension(name)
      unless name =~ /\.(.*?)$/
        name + '.png'
      else
        name
      end
    end
  
end
