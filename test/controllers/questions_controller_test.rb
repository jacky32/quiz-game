require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin_user)
    @regular = users(:one)
    @question = questions(:one)
  end

  test "regular user cannot access admin questions index" do
    sign_in_as @regular
    get admin_questions_url
    assert_redirected_to root_path
  end

  test "admin can access questions index" do
    sign_in_as @admin
    get admin_questions_url
    assert_response :success
  end

  test "admin can access new question form" do
    sign_in_as @admin
    get new_admin_question_url
    assert_response :success
  end

  test "admin should create question" do
    sign_in_as @admin

    assert_difference("Question.count") do
      post admin_questions_url, params: {
        question: {
          name: "Created By Test",
          body: "Question body created in controller test",
          hint: "Helpful hint",
          level: 3,
          active: false
        }
      }
    end

    assert_redirected_to admin_questions_url
  end

  test "admin should show question" do
    sign_in_as @admin
    get admin_question_url(@question)
    assert_includes [ 200, 406 ], response.status
  end

  test "admin should get edit" do
    sign_in_as @admin
    get edit_admin_question_url(@question)
    assert_response :success
  end

  test "admin should update question" do
    sign_in_as @admin
    patch admin_question_url(@question), params: {
      question: {
        name: "Updated Name",
        body: @question.body,
        hint: @question.hint,
        level: @question.level,
        active: @question.active
      }
    }

    assert_redirected_to admin_questions_url
    assert_equal "Updated Name", @question.reload.name
  end

  test "admin should destroy question" do
    sign_in_as @admin

    assert_difference("Question.count", -1) do
      delete admin_question_url(@question)
    end

    assert_redirected_to admin_questions_url
  end
end
