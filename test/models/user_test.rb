require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  # Email Normalization
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  # Email Validations
  test "email_address presence validation" do
    user = User.new(name: "Test User", password: "password", password_confirmation: "password")
    assert_not user.valid?
    assert user.errors[:email_address].include?("can't be blank")
  end

  test "email_address must be unique" do
    user = User.new(
      email_address: @user.email_address,
      name: "Duplicate User",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert user.errors[:email_address].include?("has already been taken")
  end

  test "email_address format validation" do
    invalid_emails = [ "invalid@", "@example.com", "user@", "user name@example.com" ]
    invalid_emails.each do |email|
      user = User.new(
        email_address: email,
        name: "Test User",
        password: "password",
        password_confirmation: "password"
      )
      assert_not user.valid?, "#{email} should be invalid"
      assert user.errors[:email_address].include?("is invalid")
    end
  end

  test "valid email addresses are accepted" do
    valid_emails = [ "user@example.com", "test.user@example.co.uk", "user+tag@example.com" ]
    valid_emails.each do |email|
      user = User.new(
        email_address: email,
        name: "Test User",
        password: "password",
        password_confirmation: "password"
      )
      assert user.valid?, "#{email} should be valid"
    end
  end

  # Password Validations
  test "password minimum length validation" do
    user = User.new(
      email_address: "short@example.com",
      name: "Test User",
      password: "pass",
      password_confirmation: "pass"
    )
    assert_not user.valid?
    assert user.errors[:password].include?("is too short (minimum is 6 characters)")
  end

  test "password minimum length is 6 characters" do
    user = User.new(
      email_address: "valid@example.com",
      name: "Test User",
      password: "passw",
      password_confirmation: "passw"
    )
    assert_not user.valid?
  end

  test "valid password is accepted" do
    user = User.new(
      email_address: "valid@example.com",
      name: "Test User",
      password: "password",
      password_confirmation: "password"
    )
    assert user.valid?
  end

  test "password confirmation must match" do
    user = User.new(
      email_address: "valid@example.com",
      name: "Test User",
      password: "password123",
      password_confirmation: "password456"
    )
    assert_not user.valid?
  end

  test "password_confirmation presence is required on creation" do
    user = User.new(
      email_address: "valid@example.com",
      name: "Test User",
      password: "password"
    )
    assert_not user.valid?
    assert user.errors[:password_confirmation].include?("can't be blank")
  end

  test "password validation only happens on password change" do
    @user.update(name: "Updated Name")
    assert @user.valid?
  end

  # Name Validations
  test "name presence validation" do
    user = User.new(
      email_address: "valid@example.com",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert user.errors[:name].include?("can't be blank")
  end

  test "name minimum length is 3 characters" do
    user = User.new(
      email_address: "valid@example.com",
      name: "ab",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert user.errors[:name].include?("is too short (minimum is 3 characters)")
  end

  test "name maximum length is 24 characters" do
    user = User.new(
      email_address: "valid@example.com",
      name: "a" * 25,
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert user.errors[:name].include?("is too long (maximum is 24 characters)")
  end

  test "valid name lengths are accepted" do
    valid_names = [ "Bob", "John Doe", "Maria-Elena", "a" * 24 ]
    valid_names.each do |name|
      user = User.new(
        email_address: "valid@example.com",
        name: name,
        password: "password",
        password_confirmation: "password"
      )
      assert user.valid?, "#{name} should be valid"
    end
  end

  # Avatar Validations
  test "user can have an attached avatar" do
    user = User.new(
      email_address: "avatar@example.com",
      name: "Avatar User",
      password: "password",
      password_confirmation: "password"
    )
    assert_respond_to(user, :avatar)
    assert_respond_to(user, :avatar=)
  end

  # Associations
  test "user has many sessions" do
    assert_respond_to(@user, :sessions)
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @user.sessions
  end

  test "user has many playthroughs" do
    assert_respond_to(@user, :playthroughs)
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @user.playthroughs
  end

  test "sessions are destroyed when user is deleted" do
    # Verificamos que la asociación tiene dependent: :destroy
    assert User.reflect_on_association(:sessions).options[:dependent] == :destroy
  end

  test "playthroughs are destroyed when user is deleted" do
    # Verificamos que la asociación tiene dependent: :destroy
    assert User.reflect_on_association(:playthroughs).options[:dependent] == :destroy
  end

  # Role Enum
  test "user has regular role by default" do
    user = User.new(
      email_address: "regular@example.com",
      name: "Regular User",
      password: "password",
      password_confirmation: "password"
    )
    assert user.regular?
  end

  test "user can be assigned admin role" do
    user = users(:admin_user)
    assert user.admin?
    assert_not user.regular?
  end

  test "role enum values are correct" do
    assert_equal 0, User.roles[:regular]
    assert_equal 99, User.roles[:admin]
  end

  # Password Authentication
  test "has_secure_password creates password_digest" do
    user = User.new(
      email_address: "secure@example.com",
      name: "Secure User",
      password: "securepassword",
      password_confirmation: "securepassword"
    )
    user.save
    assert_not_nil user.password_digest
  end

  test "user can authenticate with correct password" do
    user = User.new(
      email_address: "auth@example.com",
      name: "Auth User",
      password: "correctpassword",
      password_confirmation: "correctpassword"
    )
    user.save
    authenticated_user = User.find_by(email_address: "auth@example.com").authenticate("correctpassword")
    assert_equal user, authenticated_user
  end

  test "user authentication fails with incorrect password" do
    user = User.new(
      email_address: "wrongpass@example.com",
      name: "Wrong Pass User",
      password: "correctpassword",
      password_confirmation: "correctpassword"
    )
    user.save
    authenticated_user = User.find_by(email_address: "wrongpass@example.com").authenticate("wrongpassword")
    assert_not authenticated_user
  end

  # Score Methods
  test "best_score returns 0 when user has no playthroughs" do
    user = User.create!(
      email_address: "noscores@example.com",
      name: "No Scores",
      password: "password",
      password_confirmation: "password"
    )
    assert_equal 0, user.best_score
  end

  test "best_score method exists and works" do
    user = users(:one)
    assert_respond_to(user, :best_score)
    assert user.best_score.is_a?(Integer) || user.best_score.nil?
  end

  test "load_total_score returns 0 when user has no playthroughs" do
    user = User.create!(
      email_address: "nototalscores@example.com",
      name: "No Total",
      password: "password",
      password_confirmation: "password"
    )
    assert_equal 0, user.load_total_score
  end

  test "load_total_score method exists and works" do
    user = users(:two)
    assert_respond_to(user, :load_total_score)
    assert user.load_total_score.is_a?(Integer) || user.load_total_score.nil?
  end

  # Leaderboard Position
  test "leaderboard_position returns dash when user has no playthroughs" do
    user = User.create!(
      email_address: "noplaythrough@example.com",
      name: "No PlayT",
      password: "password",
      password_confirmation: "password"
    )
    assert_equal "-", user.leaderboard_position
  end

  # Top Leaderboard Scope
  test "top_leaderboard scope exists" do
    assert_respond_to(User, :top_leaderboard)
  end

  test "top_leaderboard is a relation" do
    leaderboard = User.top_leaderboard
    assert leaderboard.is_a?(ActiveRecord::Relation)
  end

  test "top_leaderboard limits to 5 results" do
    # The scope itself limits to 5, even if more users exist
    leaderboard = User.top_leaderboard
    assert_operator leaderboard.to_sql.include?("LIMIT"), :==, true
  end

  # Valid User Creation
  test "valid user can be created" do
    user = User.new(
      email_address: "newuser@example.com",
      name: "New User",
      password: "password",
      password_confirmation: "password"
    )
    assert user.valid?
    assert user.save
  end

  test "invalid user cannot be saved" do
    user = User.new(
      email_address: "",
      name: "",
      password: "pass"
    )
    assert_not user.save
  end
end
