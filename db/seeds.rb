# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.transaction do
  User.create! email_address: "admin@account.org", password: "adminADMIN123", password_confirmation: "adminADMIN123", role: :admin, name: "Administrator"

  # Questions

  5.times do |i|
    (1..10).to_a.each do |level|
      question = Question.new(
        name: "Sample Question #{i + 1} Level #{level}",
        body: "What is the answer to question #{i + 1} at level #{level}?",
        level: level,
        hint: "This is a hint for question #{i + 1} at level #{level}.",
        active: true,
        creator: User.first
      )

      # Create question options
      4.times do |j|
        question.question_options.build(
          text: "Option #{j + 1} for question #{i + 1} at level #{level}",
          correct: j == 0,
          question: question
        )
      end
      question.save!
    end
  end
end

# TODO: Generate users, playthroughs to fill leaderboard
