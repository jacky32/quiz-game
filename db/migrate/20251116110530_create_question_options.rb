class CreateQuestionOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :question_options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :uuid, null: false
      t.string :text, null: false
      t.boolean :correct, null: false, default: false

      t.timestamps
    end

    add_index :question_options, :uuid
  end
end
