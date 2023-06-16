class AddColumnToTestHistory < ActiveRecord::Migration[7.0]
  def change
     add_column :test_histories, :answers, :jsonb, default:{}, null: false
  end
end
