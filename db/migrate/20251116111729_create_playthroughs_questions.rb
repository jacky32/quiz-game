class CreatePlaythroughsQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :playthroughs_questions do |t|
      t.references :question, null: false, foreign_key: true
      t.references :playthrough, null: false, foreign_key: true
      t.references :selected_question_option, foreign_key: { to_table: :question_options }
      t.boolean :text_hint_used
      t.boolean :fifty_hint_used
      t.references :fifty_hint_question_option1, foreign_key: { to_table: :question_options }
      t.references :fifty_hint_question_option2, foreign_key: { to_table: :question_options }

      t.boolean :question_swap_used
      t.references :swapped_question, foreign_key: true

      t.timestamps
    end
  end
end
