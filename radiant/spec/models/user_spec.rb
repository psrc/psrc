require File.dirname(__FILE__) + '/../spec_helper'

describe User, "validations" do
  scenario :users
  test_helper :validations
  
  before :each do
    @model = @user = User.new(user_params)
    @user.confirm_password = false
  end
  
  it 'should validate length of' do
    assert_invalid :name, '100-character limit', 'x' * 101
    assert_valid :name, 'x' * 100
    
    assert_invalid :email, '255-character limit', ('x' * 247) + '@test.com'
    assert_valid :email, ('x' * 246) + '@test.com'
  end
  
  it 'should validate length ranges' do
    {
      :login => 3..40,
      :password => 5..40
    }.each do |field, range|
      max = 'x' * range.max
      min = 'x' * range.min
      one_over = 'x' + max
      one_under = min[1..-1]
      assert_invalid field, ('%d-character limit' % range.max), one_over
      assert_invalid field, ('%d-character minimum' % range.min), one_under
      assert_valid field, max, min
    end
  end
  
  it 'should validate length ranges on existing' do
    @user.save.should == true
    {
      :password => 5..40
    }.each do |field, range|
      max = 'x' * range.max
      min = 'x' * range.min
      one_over = 'x' + max
      one_under = min[1..-1]
      assert_invalid field, ('%d-character limit' % range.max), one_over
      assert_invalid field, ('%d-character minimum' % range.min), one_under
      assert_valid field, max, min
    end
  end
  
  it 'should validate presence' do
    [:name, :login, :password, :password_confirmation].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end
  end
  
  it 'should validate numericality' do
    [:id].each do |field|
      assert_valid field, '1', '0'
      assert_invalid field, 'must be a number', 'abcd', '1,2', '1.3'
    end
  end
  
  it 'should validate confirmation' do
    @user.confirm_password = true
    assert_invalid :password, 'must match confirmation', 'test'
  end
  
  it 'should validate uniqueness' do
    assert_invalid :login, 'login already in use', 'existing'
  end
  
  it 'should validate format' do
    assert_invalid :email, 'invalid e-mail address', '@test.com', 'test@', 'testtest.com',
      'test@test', 'test me@test.com', 'test@me.c'
    assert_valid :email, '', 'test@test.com'
  end
end

describe User do
  scenario :users
  
  before :each do
    @user = User.new(user_params)
    @user.confirm_password = false
  end
  
  it 'should confirm the password by default' do
    @user = User.new
    @user.confirm_password?.should == true
  end
  
  it 'should save password encrypted' do
    @user.confirm_password = true
    @user.password_confirmation = @user.password = 'test_password'
    @user.save!
    @user.password.should == User.sha1('test_password')
  end
  
  it 'should save existing but empty password' do
    @user.save!
    @user.password_confirmation = @user.password = ''
    @user.save!
    @user.password.should == User.sha1('password')
  end
  
  it 'should save existing but different password' do
    @user.save!
    @user.password_confirmation = @user.password = 'cool beans'
    @user.save!
    @user.password.should == User.sha1('cool beans')
  end
  
  it 'should save existing but same password' do
    @user.save! && @user.save!
    @user.password.should == User.sha1('password')
  end
end

describe User, "class methods" do
  scenario :users
  
  it 'should authenticate with correct username and password' do
    expected = users(:existing)
    user = User.authenticate('existing', 'password')
    user.should == expected
  end
  
  it 'should not authenticate with bad password' do
    User.authenticate('existing', 'bad password').should be_nil
  end
  
  it 'should not authenticate with bad user' do
    User.authenticate('nonexisting', 'password').should be_nil
  end
end
