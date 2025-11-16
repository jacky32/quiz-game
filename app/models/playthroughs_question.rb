class PlaythroughsQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :playthrough
  belongs_to :swapped_question, optional: true, class_name: "Question"

  belongs_to :selected_question_option, optional: true, class_name: "QuestionOption"
  belongs_to :fifty_hint_question_option, optional: true, class_name: "QuestionOption"

  validate :question_options_belong_to_question

  validate :hint_must_be_used_only_once_per_playthrough

  enum :status, { unanswered: 0, answered_correctly: 1, answered_incorrectly: 2 }

  scope :answered, -> { where.not(status: :unanswered) }

  private

  def hint_must_be_used_only_once_per_playthrough
    if text_hint_used && playthrough.playthroughs_questions.where(text_hint_used: true).where.not(id: id).exists?
      errors.add(:text_hint_used, "can only be used once per playthrough")
    end

    if fifty_hint_used && playthrough.playthroughs_questions.where(fifty_hint_used: true).where.not(id: id).exists?
      errors.add(:fifty_hint_used, "can only be used once per playthrough")
    end

    if question_swap_used && playthrough.playthroughs_questions.where(question_swap_used: true).where.not(id: id).exists?
      errors.add(:question_swap_used, "can only be used once per playthrough")
    end
  end

  def question_options_belong_to_question
    if selected_question_option && selected_question_option.question_id != question_id
      errors.add(:selected_question_option, "must belong to the associated question")
    end

    if fifty_hint_question_option && fifty_hint_question_option.question_id != question_id
      errors.add(:fifty_hint_question_option, "must belong to the associated question")
    end
  end
end
