require "test_helper"

class PlaythroughsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @playthrough = playthroughs(:one)
  end

  test "should get index" do
    get playthroughs_url
    assert_response :success
  end

  test "should get new" do
    get new_playthrough_url
    assert_response :success
  end

  test "should create playthrough" do
    assert_difference("Playthrough.count") do
      post playthroughs_url, params: { playthrough: { fifty_hint_user: @playthrough.fifty_hint_user, question_swap_used: @playthrough.question_swap_used, score: @playthrough.score, status: @playthrough.status, text_hint_used: @playthrough.text_hint_used, user_id: @playthrough.user_id } }
    end

    assert_redirected_to playthrough_url(Playthrough.last)
  end

  test "should show playthrough" do
    get playthrough_url(@playthrough)
    assert_response :success
  end

  test "should get edit" do
    get edit_playthrough_url(@playthrough)
    assert_response :success
  end

  test "should update playthrough" do
    patch playthrough_url(@playthrough), params: { playthrough: { fifty_hint_user: @playthrough.fifty_hint_user, question_swap_used: @playthrough.question_swap_used, score: @playthrough.score, status: @playthrough.status, text_hint_used: @playthrough.text_hint_used, user_id: @playthrough.user_id } }
    assert_redirected_to playthrough_url(@playthrough)
  end

  test "should destroy playthrough" do
    assert_difference("Playthrough.count", -1) do
      delete playthrough_url(@playthrough)
    end

    assert_redirected_to playthroughs_url
  end
end
