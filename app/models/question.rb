class Question < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :question_options, dependent: :destroy
  has_many :playthroughs_questions, dependent: :destroy
  has_many :playthroughs, through: :playthroughs_questions

  validates :name, presence: true
  validates :body, presence: true
  validates :level, presence: true
  validates :hint, presence: true

  validate :must_have_at_least_one_correct_option

  private

  def must_have_at_least_one_correct_option
    return unless active?
    return if question_options.correct.exists?

    errors.add(:base, "Question must have at least one correct option")
  end
end
