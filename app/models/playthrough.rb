class Playthrough < ApplicationRecord
  belongs_to :user

  has_many :playthroughs_questions, dependent: :destroy
  has_many :questions, through: :playthroughs_questions
  has_one :current_playthroughs_question, -> { where(status: :unanswered).joins(:question).order("question.level ASC") }, class_name: "PlaythroughsQuestion"
  has_one :current_question, through: :current_playthroughs_question, source: :question

  enum :status, { in_progress: 0, completed: 1 }

  before_validation :generate_questions, on: :create

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  validate :must_have_10_questions, on: :create
  validate :must_have_10_levels_of_questions, on: :create

  def text_hint_used?
    playthroughs_questions.where(text_hint_used: true).exists?
  end

  def fifty_hint_used?
    playthroughs_questions.where(fifty_hint_used: true).exists?
  end

  def question_swap_used?
    playthroughs_questions.where(question_swap_used: true).exists?
  end

  # returns false if playthrough is completed, true otherwise
  def answer_current_question(selected_option)
    pq = playthroughs_questions.find_by(question: current_question)
    if selected_option == current_question.correct_option
      pq.update(status: :answered_correctly, selected_question_option: selected_option)
      self.score += 1
    else
      pq.update(status: :answered_incorrectly, selected_question_option: selected_option)
      completed!
      return :incorrect_answer
    end

    if playthroughs_questions.unanswered.empty?
      completed!
      :finished
    else
      save!
      :correct_answer
    end
  end

  def use_text_hint
    current_playthroughs_question.update(text_hint_used: true)
  end

  def use_fifty_hint
    current_playthroughs_question.update(fifty_hint_used: true)
  end

  def use_question_swap
    fifty_hint_question_option_id = current_question.question_options.incorrect.random.first.id
    current_playthroughs_question.update(question_swap_used: true, fifty_hint_question_option_id:)
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
