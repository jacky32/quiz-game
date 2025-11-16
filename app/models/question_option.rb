class QuestionOption < ApplicationRecord
  belongs_to :question

  scope :correct, -> { where(correct: true) }

  def self.by_uuid(uuid)
    find_by(uuid: uuid)
  end
end
