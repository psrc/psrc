require File.dirname(__FILE__) + '/../spec_helper'

describe PagePart do
  test_helper :page_parts, :validations
  
  before :all do
    @part = @model = PagePart.new(PagePartTestHelper::VALID_PAGE_PART_PARAMS)
  end
  
  it 'should validate length of' do
    {
      :name => 100,
      :filter_id => 25
    }.each do |field, max|
      assert_invalid field, ('%d-character limit' % max), 'x' * (max + 1)
      assert_valid field, 'x' * max
    end
  end
  
  it 'should validate presence of' do
    [:name].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end
  end
  
  it 'should validate numericality of' do
    [:id, :page_id].each do |field|
      assert_valid field, '1', '2'
      assert_invalid field, 'must be a number', 'abcd', '1,2', '1.3'
    end
  end
end

describe PagePart, 'filter' do
  scenario :markup_pages
  
  specify 'getting and setting' do
    @part = page_parts(:textile_body)
    original = @part.filter
    assert_kind_of TextileFilter, original
    
    assert_same original, @part.filter
    
    @part.filter_id = 'Markdown'
    assert_kind_of MarkdownFilter, @part.filter
  end
end
