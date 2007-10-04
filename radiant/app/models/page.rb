class Page < ActiveRecord::Base
  
  class MissingRootPageError < StandardError
    def initialize(message = 'Database missing root page'); super end
  end
  
  # Callbacks
  before_save :update_published_at, :update_virtual
  
  # Associations
  acts_as_tree :order => 'virtual DESC, title ASC'
  has_many :parts, :class_name => 'PagePart', :order => 'id', :dependent => :destroy
  belongs_to :_layout, :class_name => 'Layout', :foreign_key => 'layout_id'
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  # Validations
  validates_presence_of :title, :slug, :breadcrumb, :status_id, :message => 'required'
  
  validates_length_of :title, :maximum => 255, :message => '%d-character limit'
  validates_length_of :slug, :maximum => 100, :message => '%d-character limit'
  validates_length_of :breadcrumb, :maximum => 160, :message => '%d-character limit'
  
  validates_format_of :slug, :with => %r{^([-_.A-Za-z0-9]*|/)$}, :message => 'invalid format'  
  validates_uniqueness_of :slug, :scope => :parent_id, :message => 'slug already in use for child of parent'
  validates_numericality_of :id, :status_id, :parent_id, :allow_nil => true, :only_integer => true, :message => 'must be a number'
  
  validate :valid_class_name
  
  include Radiant::Taggable
  include StandardTags
  include Annotatable
  
  annotate :description
  attr_accessor :request, :response
  
  set_inheritance_column :class_name
  
  def layout
    unless _layout
      parent.layout if parent?
    else
      _layout
    end
  end
  
  def cache?
    true
  end
  
  def child_url(child)
    clean_url(url + '/' + child.slug)
  end
   
  def headers
    { 'Status' => ActionController::Base::DEFAULT_RENDER_STATUS_CODE }
  end
  
  def part(name)
    parts.find_by_name name.to_s
  end
    
  def published?
    status == Status[:published]
  end
  
  def status
    Status.find(self.status_id)
  end
  def status=(value)
    self.status_id = value.id
  end
  
  def virtual
    !(read_attribute('virtual').to_s =~ /^(false|f|0|)$/)
  end
  
  def url
    if parent?
      parent.child_url(self)
    else
      clean_url(slug)
    end
  end
  
  def process(request, response)
    @request, @response = request, response
    if layout
      content_type = layout.content_type.to_s.strip
      @response.headers['Content-Type'] = content_type unless content_type.empty?
    end
    headers.each { |k,v| @response.headers[k] = v }
    @response.body = render
    @request, @response = nil, nil
  end
  
  def render
    lazy_initialize_parser_and_context
    if layout
      parse_object(layout)
    else
      render_part(:body)
    end
  end
  
  def render_part(part_name)
    lazy_initialize_parser_and_context
    part = part(part_name)
    if part
      parse_object(part)
    else
      ''
    end
  end
  
  def render_snippet(snippet, actual_page = nil)
    lazy_initialize_parser_and_context
    @context.globals.actual_page = actual_page if actual_page 
    parse_object(snippet)
  end
  
  def render_text(text)
    lazy_initialize_parser_and_context
    parse(text)
  end
  
  def find_by_url(url, live = true, clean = true)
    return nil if virtual?
    url = clean_url(url) if clean
    my_url = self.url
    if (my_url == url) && (not live or published?)
      self
    elsif (url =~ /^#{Regexp.quote(my_url)}([^\/]*)/)
      slug_child = children.find_by_slug($1)
      if slug_child
        found = slug_child.find_by_url(url, live, clean)
        return found if found
      end
      children.each do |child|
        found = child.find_by_url(url, live, clean)
        return found if found
      end
      file_not_found_types = [FileNotFoundPage] + FileNotFoundPage.descendants
      condition = (['class_name = ?']*file_not_found_types.length).join(' or ')
      file_not_found_names = file_not_found_types.map {|x| x.name}.uniq
      children.find(:first, :conditions => [condition]+file_not_found_names)
    end
  end
  
  class << self
    def find_by_url(url, live = true)
      root = find_by_parent_id(nil)
      raise MissingRootPageError unless root
      root.find_by_url(url, live)
    end
    
    def display_name(string = nil)
      if string
        @display_name = string
      else
        @display_name ||= begin
          n = name.to_s
          n.sub!(/^(.+?)Page$/, '\1')
          n.gsub!(/([A-Z])/, ' \1')
          n.strip
        end
      end
    end
    def display_name=(string)
      display_name(string)
    end
    
    def load_subclasses
      Dir["#{RADIANT_ROOT}/app/models/*_page.rb"].each do |page|
        $1.camelize.constantize if page =~ %r{/([^/]+)\.rb}
      end
    end
    
    def new_with_defaults(config = Radiant::Config)
      default_parts = config['defaults.page.parts'].to_s.strip.split(/\s*,\s*/)
      page = new
      default_parts.each do |name|
        page.parts << PagePart.new(:name => name)
      end
      default_status = config['defaults.page.status']
      page.status = Status[default_status] if default_status
      page
    end
    
    def is_descendant_class_name?(class_name)
      (Page.descendants.map(&:to_s) + [nil, "", "Page"]).include?(class_name)
    end
    
    def descendant_class(class_name)
      raise ArgumentError.new("argument must be a valid descendant of Page") unless is_descendant_class_name?(class_name)
      if ["", nil, "Page"].include?(class_name)
        Page
      else
        class_name.constantize
      end
    end
  end
  
  private

    def valid_class_name
      unless Page.is_descendant_class_name?(class_name)
        errors.add :class_name, "must be set to a valid descendant of Page"
      end
    end
  
    def attributes_protected_by_default
      super - [self.class.inheritance_column]
    end
  
    def update_published_at
      write_attribute('published_at', Time.now) if (status_id.to_i == Status[:published].id) and published_at.nil?
      true
    end
    
    def update_virtual
      if self.class != Page.descendant_class(class_name)
        write_attribute('virtual', Page.descendant_class(class_name).new.virtual?)
      else
        write_attribute('virtual', virtual?)
      end
      true
    end
    
    def clean_url(url)
      "/#{ url.strip }/".gsub(%r{//+}, '/') 
    end
    
    def parent?
      !parent.nil?
    end
    
    def lazy_initialize_parser_and_context
      unless @context and @parser
        @context = PageContext.new(self)
        @parser = Radius::Parser.new(@context, :tag_prefix => 'r')
      end
    end
    
    def parse(text)
      @parser.parse(text)
    end
    
    def parse_object(object)
      text = object.content
      text = parse(text)
      text = object.filter.filter(text) if object.respond_to? :filter_id
      text
    end
    
    def tag(*args, &block)
      @context.define_tag(*args, &block)
    end
  
end

Page.load_subclasses
