require "test_helper"

class PlaythroughsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @playthrough = playthroughs(:one)
  end

  test "requires authentication" do
    get playthroughs_url
    assert_redirected_to new_session_path
  end

  test "show route is reachable for authenticated user" do
    sign_in_as @user
    get playthroughs_url
    assert_includes [ 200, 422 ], response.status
  end

  test "answer_question route requires params" do
    sign_in_as @user
    post answer_question_playthroughs_url, params: { playthrough: { question_option_id: "invalid" } }
    assert_includes [ 302, 422 ], response.status
  end

  test "use_text_hint route is available" do
    sign_in_as @user
    post use_text_hint_playthroughs_url
    assert_includes [ 302, 422 ], response.status
  end

  test "use_fifty_hint route is available" do
    sign_in_as @user
    post use_fifty_hint_playthroughs_url
    assert_includes [ 302, 422 ], response.status
  end

  test "use_question_swap route is available" do
    sign_in_as @user
    post use_question_swap_playthroughs_url
    assert_includes [ 302, 422 ], response.status
  end
end
