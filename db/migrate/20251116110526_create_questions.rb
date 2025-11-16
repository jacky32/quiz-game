class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.string :name, null: false
      t.text :body, null: false
      t.integer :level, null: false
      t.text :hint, null: false
      t.boolean :active, null: false, default: false
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
