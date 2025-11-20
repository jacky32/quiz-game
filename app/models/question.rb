class Question < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :question_options, dependent: :destroy
  has_one :correct_option, -> { where(correct: true) }, class_name: "QuestionOption"
  has_many :incorrect_options, -> { where(correct: false) }, class_name: "QuestionOption"
  has_many :playthroughs_questions, dependent: :destroy
  has_many :playthroughs, through: :playthroughs_questions

  validates :name, presence: true
  validates :body, presence: true
  validates :level, presence: true, inclusion: { in: 1..10 }
  validates :hint, presence: true

  validate :must_have_one_correct_option

  scope :active, -> { where(active: true) }
  scope :order_random, -> { order("RANDOM()") }

  accepts_nested_attributes_for :correct_option, :incorrect_options

  def can_destroy?
    playthroughs_questions.empty?
  end

  private

  def must_have_one_correct_option
    return unless active?
    return if question_options.select { it["correct"] == true }.size == 1

    errors.add(:base, "Question must have one correct option")
  end
end
