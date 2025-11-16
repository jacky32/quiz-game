class Playthrough < ApplicationRecord
  belongs_to :user

  has_many :playthroughs_questions, dependent: :destroy
  has_many :questions, through: :playthroughs_questions
end
