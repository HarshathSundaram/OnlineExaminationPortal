class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.string :description
      t.references :courses, null: false, foreign_key: true

      t.timestamps
    end
  end
end
