class CreateTestHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :test_histories do |t|
      t.integer :mark_scored
      t.integer :total_mark
      t.references :test, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.timestamps
    end
  end
end
