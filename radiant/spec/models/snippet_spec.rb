require File.dirname(__FILE__) + '/../spec_helper'

describe Snippet do
  scenario :snippets
  test_helper :snippets, :validations
  
  before :all do
    @snippet = @model = Snippet.new(snippet_params)
  end
  
  it 'validates length of' do
    {
      :name => 100,
      :filter_id => 25
    }.each do |field, max|
      assert_invalid field, ('%d-character limit' % max), 'x' * (max + 1)
      assert_valid field, 'x' * max
    end
  end
  
  it 'validates presence of' do
    [:name].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end
  end
  
  it 'validates uniqueness of' do
    assert_invalid :name, 'name already in use', 'first', 'another', 'markdown'
    assert_valid :name, 'just-a-test'
  end
  
  it 'validates format of name' do
    assert_valid :name, 'abc', 'abcd-efg', 'abcd_efg', 'abc.html', '/', '123'
    assert_invalid :name, 'cannot contain spaces or tabs'
  end
  
  it 'filter' do
    @snippet = snippets(:markdown)
    @snippet.filter.should be_kind_of(MarkdownFilter)
  end
end
