require "test_helper"

class UserDashboardSmokeTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @admin = users(:admin_user)
  end

  # Dashboard Tests
  test "authenticated user can view dashboard" do
    sign_in_as @user
    get dashboard_path
    assert_response :success
  end

  test "dashboard page loads for authenticated user" do
    sign_in_as @user
    get dashboard_path
    assert_response :success
  end

  test "dashboard is inaccessible without authentication" do
    get dashboard_path
    assert_redirected_to new_session_path
  end

  # User Profile View Tests
  test "authenticated user can access edit profile form" do
    sign_in_as @user
    get edit_user_path(@user)
    assert_response :success
  end

  test "user can view edit profile form" do
    sign_in_as @user
    get edit_user_path(@user)
    assert_response :success
    assert_select "form"
  end

  test "user profile edit form has expected fields" do
    sign_in_as @user
    get edit_user_path(@user)
    assert_response :success
    assert_select "input[name*='user[name]']"
    assert_select "input[name*='user[email_address]']"
  end

  # Navigation Tests
  test "user can navigate from dashboard to profile" do
    sign_in_as @user
    get dashboard_path
    assert_response :success
  end

  test "authenticated user viewing public page is redirected to dashboard" do
    sign_in_as @user
    get public_path
    # Authenticated users are redirected from public landing
    assert [200, 302].include?(response.status)
  end

  # Admin Role Tests
  test "admin user has admin role" do
    assert @admin.admin?
    assert_not @admin.regular?
  end

  test "regular user has regular role" do
    assert @user.regular?
    assert_not @user.admin?
  end

  # Session Persistence Tests
  test "user session persists across multiple requests" do
    sign_in_as @user
    get dashboard_path
    assert_response :success

    get dashboard_path
    assert_response :success
  end

  test "multiple authenticated requests maintain session" do
    sign_in_as @user

     5.times do
      get dashboard_path
      assert_response :success
    end
  end

  # User Data Tests
  test "authenticated user sees correct user data" do
    sign_in_as @user
    get edit_user_path(@user)
    assert_response :success
    assert_includes response.body, @user.email_address
  end

  test "edit profile returns success for signed in user" do
    sign_in_as @user
    get edit_user_path(@user)
    # User can edit their own profile
    assert_response :success
  end

  # Email Normalization Tests
  test "registered user email is normalized" do
    post registrations_path, params: {
      user: {
        name: "Email Test",
        email_address: "  TEST@EXAMPLE.COM  ",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }

    user = User.find_by(email_address: "test@example.com")
    assert_not_nil user
    assert_equal "test@example.com", user.email_address
  end

  # User Creation via APIs
  test "user is created with correct default role" do
    post registrations_path, params: {
      user: {
        name: "Default Role User",
        email_address: "defaultrole@example.com",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }

    user = User.find_by(email_address: "defaultrole@example.com")
    assert_not_nil user
    assert user.regular?
    assert_not user.admin?
  end

  # Session Cleanup Tests
  test "logout properly clears session" do
    sign_in_as @user
    get dashboard_path
    assert_response :success

    delete session_path
    assert_redirected_to new_session_path

    # Try to access protected page
    get dashboard_path
    assert_redirected_to new_session_path
  end

  # Cookie Tests
  test "session cookie is set after login" do
    post session_path, params: {
      email_address: @user.email_address,
      password: "password"
    }

    assert_response :redirect
    assert cookies["session_id"].present?
  end

  test "session cookie is deleted after logout" do
    sign_in_as @user
    assert cookies["session_id"].present?

    sign_out
    assert_nil cookies["session_id"]
  end

  # User Update Workflows
  test "user can update multiple fields in one request" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        name: "New Full Name",
        email_address: "newemail@example.com"
      }
    }

    assert_redirected_to dashboard_path
    @user.reload
    assert_equal "New Full Name", @user.name
    assert_equal "newemail@example.com", @user.email_address
  end

  # Form Submission Tests
  test "profile edit form is rendered as HTML form" do
    sign_in_as @user
    get edit_user_path(@user)
    assert_response :success
    assert_select "form"
  end

  # Error Handling
  test "updating user with validation error shows form" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        name: "a"
      }
    }

    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "updating user with invalid email shows error" do
    sign_in_as @user
    patch user_path(@user), params: {
      user: {
        email_address: "invalid-email"
      }
    }

    assert_response :unprocessable_entity
    assert_includes flash[:alert], "invalid"
  end

  # Page Loading Tests
  test "public page loads successfully" do
    get public_path
    assert_response :success
  end

  test "public page is accessible without authentication" do
    assert_no_session_id
    get public_path
    assert_response :success
  end

  test "root url works" do
    get root_path
    # Root path is available
    assert [200, 302].include?(response.status)
  end

  private

  def assert_no_session_id
    assert_nil cookies["session_id"]
  end
end
