class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :sessions, dependent: :destroy
  has_many :playthroughs, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:password_digest] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:password_digest] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:password_digest] }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  validate :acceptable_avatar_size

  enum :role, { regular: 0, admin: 99 }


  def best_score
    playthroughs.maximum(:score) || 0
  end

  def leaderboard_position
    User
      .joins(:playthroughs)
      .group("users.id")
      .select("users.*, MAX(playthroughs.score)")
      .order("MAX(playthroughs.score) DESC")
      .pluck(:id)
      .index(id)
      &.+(1) || "-" # Convert zero-based index to one-based position
  end

  private

  def acceptable_avatar_size
    return unless avatar.attached?

    if avatar.blob.byte_size > 2.megabytes
      errors.add(:avatar, "is too big. Maximum size is 2MB.")
    end

    acceptable_types = [ "image/jpeg", "image/png", "image/gif" ]
    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, "must be a JPEG, PNG, or GIF.")
    end
  end
end
