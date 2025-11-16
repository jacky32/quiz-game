class QuestionOption < ApplicationRecord
  belongs_to :question
  has_many :playthroughs_questions_as_selected, class_name: "PlaythroughsQuestion", foreign_key: "selected_question_option_id", dependent: :nullify
  has_many :playthroughs_questions_as_fifty_hint, class_name: "PlaythroughsQuestion", foreign_key: "fifty_hint_question_option_id", dependent: :nullify
  before_create :assign_uuid

  scope :correct, -> { where(correct: true) }
  scope :incorrect, -> { where(correct: false) }
  scope :random, -> { order("RANDOM()") }

  def self.by_uuid(uuid)
    find_by(uuid: uuid)
  end

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end
