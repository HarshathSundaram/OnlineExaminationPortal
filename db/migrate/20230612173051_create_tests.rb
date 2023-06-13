class CreateTests < ActiveRecord::Migration[7.0]
  def change
    create_table :tests do |t|
      t.references :testable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
