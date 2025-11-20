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
  unless User.admin.exists?
    User.create! email_address: "admin@account.org", password: "adminADMIN123", password_confirmation: "adminADMIN123", role: :admin, name: "Administrator"
  end
  # Questions

  questions = File.read(Rails.root.join("data", "questions.json"))
  questions_data = JSON.parse(questions)
  questions_data.each do |question|
    db_question = Question.new(
      name: question["question_name"],
      body: question["question"],
      level: question["level"],
      hint: question["hint"],
      active: true,
      creator: User.first
    )

    db_question.question_options.build(text: question["correct_option"], correct: true, question: db_question)
    db_question.question_options.build(text: question["incorrect_option1"], correct: false, question: db_question)
    db_question.question_options.build(text: question["incorrect_option2"], correct: false, question: db_question)
    db_question.question_options.build(text: question["incorrect_option3"], correct: false, question: db_question)
    db_question.save!
  end
end
