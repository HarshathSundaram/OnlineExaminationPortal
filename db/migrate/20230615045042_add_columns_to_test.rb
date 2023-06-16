class AddColumnsToTest < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :name, :string
    add_column :tests, :questions, :jsonb, default:{}, null: false
  end
end
