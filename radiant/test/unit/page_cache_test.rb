require File.dirname(__FILE__) + '/../test_helper'

class PageCacheTest < Test::Unit::TestCase
  class SilentLogger
    def method_missing(*args); end
  end
  
  def setup
    @dir = "#{RAILS_ROOT}/test/cache"
    @cache = PageCache.new(
      :directory => @dir,
      :perform_caching => true
    )
  end
  
  def teardown
    FileUtils.rm_rf @dir if File.exists? @dir
  end
  
  def test_initialize__defaults
    @cache = PageCache.new
    assert_equal   "#{RAILS_ROOT}/cache", @cache.directory
    assert_equal   5.minutes,             @cache.expire_time
    assert_equal   '.html',               @cache.default_extension
    assert_equal   false,                 @cache.perform_caching
    assert_kind_of Logger,                @cache.logger
  end
  
  def test_initialize__with_options
    @cache = PageCache.new(
      :directory         => "test",
      :expire_time       => 5,
      :default_extension => ".xhtml",
      :perform_caching   => false,
      :logger            => SilentLogger.new
    )
    assert_equal   "test",       @cache.directory
    assert_equal   5,            @cache.expire_time
    assert_equal   ".xhtml",     @cache.default_extension
    assert_equal   false,        @cache.perform_caching
    assert_kind_of SilentLogger, @cache.logger
  end
  
  def test_brackets__set
    ['test/me', '/test/me', 'test/me/', '/test/me/', 'test//me'].each do |url|
      @cache[url] = 'content'
      name = "#{@dir}/test/me.html"
      assert File.exists?(name), "url: #{url}"
      assert_equal 'content', file(name), "url: #{url}"
    end
  end
  def test_brackets__set_without_caching
    @cache.perform_caching = false
    @cache['test'] = 'content'
    assert !File.exists?("#{@dir}/test.html")
  end
  
  def test_brackets__read
    @cache['/test/me'] = 'content'
    ['test/me', '/test/me', 'test/me/', '/test/me/', 'test//me'].each do |url|
      assert_equal 'content', @cache[url], "url: #{url}"
    end
  end
  def test_brackets__read_nonexistant
    assert_equal nil, @cache['nothing/here']
  end
  def test_brackets__read_without_caching
    @cache['/test/me'] = 'content'
    @cache.perform_caching = false
    assert_equal nil, @cache['/test/me']
  end
  
  def test_timed_expire
    @cache.expire_time = 1
    name = '/test'
    @cache[name] = 'content'
    assert_equal 'content', @cache[name]
    
    sleep 1.5
    assert_equal nil, @cache[name]
    assert !File.exists?("#{@dir}#{name}.html")
  end
  
  def test_cache
    result = @cache.cache('test', 'content')
    assert_equal 'content', @cache['test']
    assert_equal 'content', result
  end
  
  def test_expire
    @cache['test'] = 'content'
    result = @cache.expire('test')
    assert_equal nil, @cache['test']
    assert_equal 'content', result
  end
  
  def test_clear
    @cache['test1'] = 'content'
    @cache['test2'] = 'content'
    assert_equal 2, Dir["#{@dir}/*"].size
    
    @cache.clear
    assert_equal 0, Dir["#{@dir}/*"].size
  end
  
  # Class Methods
  
  def test_instance
    first = PageCache.instance
    second = PageCache.instance
    assert_same first, second
  end
  
  private
  
    def file(filename)
      open(filename) { |f| f.read } rescue ''
    end
  
end