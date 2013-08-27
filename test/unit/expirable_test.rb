require 'test_helper'

class ExpirableTest < Test::Unit::TestCase

  def setup
    super
    setup_db
    Name.create(name: "expired record", expires_at: Time.now - 1.hour)
    Name.create(name: "future expired record", expires_at: Time.now + 2.hours)
    Name.create(name: "doesn't expire", expires_at: nil)

    Token.create(token: "expired", good_until: Time.now - 2.days)
  end

  def teardown
    teardown_db
    super
  end

  def test_class_registration
    assert_equal([ExpirableName, ExpirableNameDefault, Token], ActsAsExpirable.expirable_classes)
  end

  def test_default_value
    assert name = ExpirableNameDefault.create(name: "foo")
    assert name.expires_at, "expires_at should be set"
    assert_equal Time.parse("2014-02-03 09:00:45 UTC"), name.expires_at
  end

  def test_default_value_lambda
    assert token = Token.create(token: "foo")
    assert token.good_until
    assert (Time.now.to_i + 1.day) - token.good_until.to_i <= 1, "should be set to nowish"
  end

  def test_expired_scope
    assert_equal(1, ExpirableName.expired.count)
  end

  def test_unexpired_scope
    assert_equal(2, ExpirableName.unexpired.count)
  end

  def test_destroy_all
    count = ExpirableName.count
    ExpirableName.destroy_expired
    assert_equal count - 1, ExpirableName.count
  end

  def test_destroy_all_special_column
    count = Token.count
    Token.destroy_expired
    assert_equal count - 1, Token.count
  end

  def test_cleanup
    name_count = ExpirableName.count
    token_count = Token.count

    ActsAsExpirable.cleanup!

    assert_equal name_count - 1, ExpirableName.count
    assert_equal token_count - 1, Token.count
  end

  def test_expired
    name = ExpirableName.find_by_name("expired record")
    assert name.expired?
  end

  def test_expiring
    name = ExpirableName.find_by_name("doesn't expire")
    assert !name.expired?

    # doesn't actually write
    name.expire
    assert name.expired?

    name.reload
    assert !name.expired?
    name.expire!

    name.reload
    assert name.expired?
  end

end
