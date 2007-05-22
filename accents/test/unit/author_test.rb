require File.dirname(__FILE__) + '/../test_helper'

class AuthorTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :authors

  def test_should_create_author
    assert_difference Author, :count do
      author = create_author
      assert !author.new_record?, "#{author.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference Author, :count do
      u = create_author(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference Author, :count do
      u = create_author(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference Author, :count do
      u = create_author(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference Author, :count do
      u = create_author(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    authors(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal authors(:quentin), Author.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    authors(:quentin).update_attributes(:login => 'quentin2')
    assert_equal authors(:quentin), Author.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_author
    assert_equal authors(:quentin), Author.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    authors(:quentin).remember_me
    assert_not_nil authors(:quentin).remember_token
    assert_not_nil authors(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    authors(:quentin).remember_me
    assert_not_nil authors(:quentin).remember_token
    authors(:quentin).forget_me
    assert_nil authors(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    authors(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil authors(:quentin).remember_token
    assert_not_nil authors(:quentin).remember_token_expires_at
    assert authors(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    authors(:quentin).remember_me_until time
    assert_not_nil authors(:quentin).remember_token
    assert_not_nil authors(:quentin).remember_token_expires_at
    assert_equal authors(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    authors(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil authors(:quentin).remember_token
    assert_not_nil authors(:quentin).remember_token_expires_at
    assert authors(:quentin).remember_token_expires_at.between?(before, after)
  end

  protected
    def create_author(options = {})
      Author.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
