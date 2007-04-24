require File.dirname(__FILE__) + '/../test_helper'

class ResponseCacheTest < Test::Unit::TestCase
  class SilentLogger
    def method_missing(*args); end
  end
  
  class TestResponse < ActionController::TestResponse
    def initialize(body = '', headers = {})
      self.body = body
      self.headers = headers
    end
  end
  
  def setup
    @dir = "#{RAILS_ROOT}/test/cache"
    @old_perform_caching = ResponseCache.defaults[:perform_caching]
    ResponseCache.defaults[:perform_caching] = true
    @cache = ResponseCache.new(
      :directory => @dir,
      :perform_caching => true
    )
    @cache.clear
  end
  
  def teardown
    ResponseCache.defaults[:perform_caching] = @old_preform_caching
    FileUtils.rm_rf @dir if File.exists? @dir
  end
  
  def test_initialize__defaults
    @cache = ResponseCache.new
    assert_equal   "#{RAILS_ROOT}/cache", @cache.directory
    assert_equal   5.minutes,             @cache.expire_time
    assert_equal   '.yml',                @cache.default_extension
    assert_equal   true,                  @cache.perform_caching
    assert_kind_of Logger,                @cache.logger
  end
  
  def test_initialize__with_options
    @cache = ResponseCache.new(
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
  
  def test_cache_response
    ['test/me', '/test/me', 'test/me/', '/test/me/', 'test//me'].each do |url|
      @cache.clear
      response = response('content', 'Last-Modified' => 'Tue, 27 Feb 2007 06:13:43 GMT')
      response.cache_timeout = Time.gm(2007, 2, 8, 17, 37, 9)
      @cache.cache_response(url, response)
      name = "#{@dir}/test/me.yml"
      assert File.exists?(name), "url: #{url}"
      assert_equal "--- \nexpires: 2007-02-08 17:37:09 Z\nheaders: \n  Last-Modified: Tue, 27 Feb 2007 06:13:43 GMT\n", file(name), "url: #{url}"
      data_name = "#{@dir}/test/me.data"
      assert_equal "content", file(data_name), "url: #{url}"
    end
  end
  
  def test_cache_response_with_extension
    @cache.cache_response("styles.css", response('content'))
    assert File.exists?("#{@dir}/styles.css.yml")
  end
  
  def test_cache_response_without_caching
    @cache.perform_caching = false
    @cache.cache_response('test', response('content'))
    assert !File.exists?("#{@dir}/test.yml")
  end
  
  def test_update_response
    @cache.cache_response('/test/me', response('content'))
    ['test/me', '/test/me', 'test/me/', '/test/me/', 'test//me'].each do |url|
      assert_equal 'content', @cache.update_response(url, response, ActionController::TestRequest).body, "url: #{url}"
    end
  end
  def test_update_response__nonexistant
    assert_equal '', @cache.update_response('nothing/here', response, ActionController::TestRequest).body
  end
  def test_update_response_without_caching
    @cache.cache_response('/test/me', response('content'))
    @cache.perform_caching = false
    assert_equal '', @cache.update_response('/test/me', response, ActionController::TestRequest).body
  end
  
  def test_cache
    result = @cache.cache_response('test', response('content', 'Content-Type' => 'text/plain'))
    cached = @cache.update_response('test', response, ActionController::TestRequest)
    assert_equal 'content', cached.body
    assert_equal 'text/plain', cached.headers['Content-Type']
    assert_kind_of TestResponse, result
  end
  
  def test_expire_response
    @cache.cache_response('test', response('content'))
    @cache.expire_response('test')
    assert_equal '', @cache.update_response('test', response, ActionController::TestRequest).body
  end
  
  def test_clear
    @cache.cache_response('test1', response('content'))
    @cache.cache_response('test2', response('content'))
    assert_equal 4, Dir["#{@dir}/*"].size
    
    @cache.clear
    assert_equal 0, Dir["#{@dir}/*"].size
  end
  
  def test_response_cached
    assert_equal false, @cache.response_cached?('test')
    result = @cache.cache_response('test', response('content'))
    assert_equal true, @cache.response_cached?('test')
  end
  def test_response_cached_timed_out
    @cache.expire_time = 1
    result = @cache.cache_response('test', response('content'))
    sleep 1.5
    assert_equal false, @cache.response_cached?('test')
  end
  def test_response_cached_timed_out_with_response_setting
    @cache.expire_time = 1
    response = response('content')
    response.cache_timeout = 3.seconds
    result = @cache.cache_response('test', response)
    sleep 1.5
    assert_equal true, @cache.response_cached?('test')
    sleep 2
    assert_equal false, @cache.response_cached?('test')
  end
  def test_send_using_x_sendfile
    @cache.use_x_sendfile = true
    result = @cache.cache_response('test', response('content', 'Content-Type' => 'text/plain'))
    cached = @cache.update_response('test', response, ActionController::TestRequest)
    assert_equal '', cached.body
    assert_equal "#{@dir}/test.data", cached.headers['X-Sendfile']
    assert_equal 'text/plain', cached.headers['Content-Type']
    assert_kind_of TestResponse, result
  end
  def test_send_cached_page_with_last_modified
    last_modified = Time.now.httpdate
    result = @cache.cache_response('test', response('content', 'Last-Modified' => last_modified))
    request = ActionController::TestRequest.new
    request.env = { 'HTTP_IF_MODIFIED_SINCE' => last_modified }
    second_call = @cache.update_response('test', response, request)
    assert_match /^304/, second_call.headers['Status']
    assert_equal '', second_call.body
    assert_kind_of TestResponse, result
  end
  def test_send_cached_page_with_old_last_modified
    last_modified = Time.now.httpdate
    result = @cache.cache_response('test', response('content', 'Last-Modified' => last_modified))
    request = ActionController::TestRequest.new
    request.env = { 'HTTP_IF_MODIFIED_SINCE' => 5.minutes.ago.httpdate }
    second_call = @cache.update_response('test', response, request)
    assert_equal 'content', second_call.body
    assert_kind_of TestResponse, result
  end

  

  
  # Class Methods
  
  def test_instance
    assert_same ResponseCache.instance, ResponseCache.instance
  end
  
  private
  
    def file(filename)
      open(filename) { |f| f.read } rescue ''
    end
    
    def response(*args)
      TestResponse.new(*args)
    end
  
end
