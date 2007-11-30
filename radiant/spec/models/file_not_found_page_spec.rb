require File.dirname(__FILE__) + '/../spec_helper'

describe FileNotFoundPage do
  scenario :file_not_found
  test_helper :render
  
  before(:all) do
    @page = pages(:file_not_found)
  end
  
  it 'should have a working url tag' do
    assert_renders 'http://testhost.tld/gallery/asdf?param=4', '<r:attempted_url />', '/gallery/asdf?param=4'
  end

  it 'should correclty quote the url' do
    assert_renders 'http://testhost.tld/gallery/&lt;script&gt;alert(&quot;evil&quot;)&lt;/script&gt;', '<r:attempted_url />', '/gallery/<script>alert("evil")</script>'
  end
  
  it 'should be a virtual page' do
    @page.should be_virtual
  end
  
  it 'should not be cached' do
    @page.should_not be_cache
  end
  
  it 'should have the correct headers' do
    assert_headers({'Status' => '404 Not Found'}, '/gallery/asdf')
  end
  
end
