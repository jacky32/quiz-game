class Playthrough < ApplicationRecord
  belongs_to :user

  has_many :playthroughs_questions, dependent: :destroy
  has_many :questions, through: :playthroughs_questions

  enum :status, { in_progress: 0, completed: 1 }

  before_validation :generate_questions, on: :create

  validate :must_have_10_questions, on: :create
  validate :must_have_10_levels_of_questions, on: :create

  def current_question
    playthroughs_questions.unanswered.last.question
  end

  private

  def generate_questions
    Question.active.where(level: (1..10)).random.distinct(:level).limit(10).find_each do |question|
      playthroughs_questions.build(question: question)
    end
  end

  def must_have_10_questions
    unless playthroughs_questions.size == 10
      errors.add(:base, "Playthrough must have 10 questions")
    end
  end

  def must_have_10_levels_of_questions
    levels = Question.active.where(id: playthroughs_questions.map { it.question_id }).pluck(:level)
    if levels.sort != (1..10).to_a
      errors.add(:base, "Playthrough must have questions for all 10 levels")
    end
  end
end
