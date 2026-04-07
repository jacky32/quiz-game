require "test_helper"

class QuestionOptionsControllerTest < ActionDispatch::IntegrationTest
  test "public question_options route currently has no controller" do
    assert_raises(ActionDispatch::MissingController) do
      get question_options_url
    end
  end

  test "question options are managed through admin question form" do
    question = questions(:one)
    assert question.question_options.exists?
  end
end
