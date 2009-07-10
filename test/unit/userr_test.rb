require File.dirname(__FILE__) + '/../test_helper'

class UserrTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :userrs

  def test_should_create_userr
    assert_difference Userr, :count do
      userr = create_userr
      assert !userr.new_record?, "#{userr.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference Userr, :count do
      u = create_userr(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference Userr, :count do
      u = create_userr(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference Userr, :count do
      u = create_userr(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference Userr, :count do
      u = create_userr(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    userrs(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal userrs(:quentin), Userr.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    userrs(:quentin).update_attributes(:login => 'quentin2')
    assert_equal userrs(:quentin), Userr.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_userr
    assert_equal userrs(:quentin), Userr.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    userrs(:quentin).remember_me
    assert_not_nil userrs(:quentin).remember_token
    assert_not_nil userrs(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    userrs(:quentin).remember_me
    assert_not_nil userrs(:quentin).remember_token
    userrs(:quentin).forget_me
    assert_nil userrs(:quentin).remember_token
  end

  protected
    def create_userr(options = {})
      Userr.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
