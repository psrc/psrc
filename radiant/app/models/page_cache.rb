class PageCache
  include ActionController::Benchmarking::ClassMethods
  include ActionController::Caching::Pages::ClassMethods
  
  private :expire_page, :cache_page, :caches_page, :benchmark, :silence
  
  @@defaults = {
    :directory => ActionController::Base.page_cache_directory,
    :expire_time => 5.minutes,
    :default_extension => '.html',
    :perform_caching => true,
    :logger => ActionController::Base.logger
  }
  cattr_accessor :defaults
  
  attr_accessor :directory, :expire_time, :default_extension, :perform_caching, :logger
  
  def initialize(options = {})
    options = options.symbolize_keys.reverse_merge(defaults)
    self.directory         = options[:directory]
    self.expire_time       = options[:expire_time]
    self.default_extension = options[:default_extension]
    self.perform_caching   = options[:perform_caching]
    self.logger            = options[:logger]
  end
  
  def []=(path, content)
    path = clean(path)
    cache_page(content, path)
    content
  end
  alias :cache :[]=
  
  def [](path)
    if perform_caching
      path = clean(path)
      if time_to_expire_page?(path)
        expire_page(path)
        nil
      else
        read_page(path)
      end
    end
  end
  
  def expire(path)
    path = clean(path)
    content = read_page(path)
    expire_page(path)
    content
  end
  
  def clear
    Dir["#{directory}/*"].each do |f|
      FileUtils.rm_rf f
    end
  end
  
  def self.instance
    @@instance ||= new
  end
  
  private
    def clean(path)
      path = path.gsub(%{/+}, '/')
      %r{^/?(.*?)/?$}.match(path)
      "/#{$1}"
    end
    
    def read_page(path)
      name = page_cache_path(path)
      File.open(name, "rb") { |f| f.read } if File.exists? name
    end
  
    def time_to_expire_page?(path)
      name = page_cache_path(path)
      File.exists?(name) and (File.stat(name).mtime < (Time.now - @expire_time))
    end
  
    def page_cache_directory
      @directory
    end
  
    def page_cache_extension
      @default_extension
    end
end