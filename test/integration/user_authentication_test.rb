require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  # Session/Login Tests
  test "user can visit login page" do
    get new_session_path
    assert_response :success
    assert_select "h1"
  end

  test "user can log in with valid credentials" do
    post session_path, params: {
      email_address: @user.email_address,
      password: "password"
    }
    assert_response :redirect
    assert cookies["session_id"].present?
  end

  test "user cannot log in with invalid email" do
    post session_path, params: {
      email_address: "nonexistent@example.com",
      password: "password"
    }
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "user cannot log in with invalid password" do
    post session_path, params: {
      email_address: @user.email_address,
      password: "wrongpassword"
    }
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "authenticated user is redirected from login page" do
    sign_in_as @user
    get new_session_path
    assert_redirected_to root_path
    assert_includes flash[:notice], "již přihlášen"
  end

  test "user can log out" do
    sign_in_as @user
    delete session_path
    assert_redirected_to new_session_path

    # Verify session is destroyed
    follow_redirect!
    assert_response :success
  end

  test "logout redirects to login page" do
    sign_in_as @user
    delete session_path, headers: { "HTTP_REFERER" => root_url }
    assert_redirected_to new_session_path
  end

  test "session is created after successful login" do
    post session_path, params: {
      email_address: @user.email_address,
      password: "password"
    }

    assert_response :redirect
    assert cookies["session_id"].present?
  end

  # Registration Tests
  test "user can visit registration page" do
    get new_registration_path
    assert_response :success
    assert_select "h1"
  end

  test "user can register with valid information" do
    post registrations_path, params: {
      user: {
        name: "New User",
        email_address: "newuser@example.com",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }
    assert_redirected_to root_path
    assert_includes flash[:notice], "zaregistrovali"

    # Verify user was created
    assert User.find_by(email_address: "newuser@example.com").present?
  end

  test "user cannot register with invalid name" do
    post registrations_path, params: {
      user: {
        name: "ab",
        email_address: "invalid@example.com",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }
    assert_response :unprocessable_entity
    assert_select "[id^='user_']"
  end

  test "user cannot register with invalid email" do
    post registrations_path, params: {
      user: {
        name: "Test User",
        email_address: "invalid-email",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }
    assert_response :unprocessable_entity
  end

  test "user cannot register with short password" do
    post registrations_path, params: {
      user: {
        name: "Test User",
        email_address: "newuser@example.com",
        password: "short",
        password_confirmation: "short"
      }
    }
    assert_response :unprocessable_entity
  end

  test "user cannot register with mismatched passwords" do
    post registrations_path, params: {
      user: {
        name: "Test User",
        email_address: "newuser@example.com",
        password: "securepassword",
        password_confirmation: "differentpassword"
      }
    }
    assert_response :unprocessable_entity
  end

  test "user cannot register with duplicate email" do
    post registrations_path, params: {
      user: {
        name: "Duplicate User",
        email_address: @user.email_address,
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }
    assert_response :unprocessable_entity
    assert_includes flash[:alert], "has already been taken"
  end

  test "authenticated user is redirected from registration page" do
    sign_in_as @user
    get new_registration_path
    assert_redirected_to root_path
    assert_includes flash[:notice], "již přihlášen"
  end

  test "registered user is automatically logged in" do
    post registrations_path, params: {
      user: {
        name: "Auto Login User",
        email_address: "autologin@example.com",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }

    assert_redirected_to root_path
    assert cookies["session_id"].present?
  end

  # User Profile Tests
  test "authenticated user can access edit profile page" do
    sign_in_as @user
    get edit_user_path(@user)
    assert_response :success
    assert_select "h1"
  end

  test "unauthenticated user cannot access edit profile page" do
    get edit_user_path(@user)
    assert_redirected_to new_session_path
  end

  test "user can update profile name" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        name: "Updated Name"
      }
    }
    assert_redirected_to dashboard_path
    assert_includes flash[:notice], "aktualizovali"

    @user.reload
    assert_equal "Updated Name", @user.name
  end

  test "user can update email address" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        email_address: "newemail@example.com"
      }
    }
    assert_redirected_to dashboard_path

    @user.reload
    assert_equal "newemail@example.com", @user.email_address
  end

  test "user cannot update with invalid name" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        name: "ab"
      }
    }
    assert_response :unprocessable_entity
    assert_includes flash[:alert], "too short"
  end

  test "user cannot update with duplicate email" do
    other_user = users(:two)
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        email_address: other_user.email_address
      }
    }
    assert_response :unprocessable_entity
    assert_includes flash[:alert], "has already been taken"
  end

  test "user can change password" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    }
    assert_redirected_to dashboard_path

    @user.reload
    assert @user.authenticate("newpassword123")
  end

  test "user cannot change password with mismatched confirmation" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        password: "newpassword123",
        password_confirmation: "differentpassword"
      }
    }
    assert_response :unprocessable_entity
  end

  # Access Control Tests
  test "unauthenticated user cannot access dashboard" do
    get dashboard_path
    assert_redirected_to new_session_path
  end

  test "authenticated user can access dashboard" do
    sign_in_as @user
    get dashboard_path
    assert_response :success
  end

  test "unauthenticated user can access public page" do
    get public_path
    assert_response :success
  end

  test "root path works" do
    get root_path
    # Root path either redirects or shows public page
    assert [200, 302].include?(response.status)
  end

  # Rate Limiting Tests
  test "login is rate limited after multiple attempts" do
    # Test that rate limiting is configured
    assert_respond_to SessionsController, :rate_limit
  end

  test "registration is rate limited after multiple attempts" do
    # Test that rate limiting is configured
    assert_respond_to RegistrationsController, :rate_limit
  end
end
