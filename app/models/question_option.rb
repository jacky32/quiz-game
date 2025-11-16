class QuestionOption < ApplicationRecord
  belongs_to :question
  before_create :assign_uuid

  scope :correct, -> { where(correct: true) }

  def self.by_uuid(uuid)
    find_by(uuid: uuid)
  end

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end
