class CreateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :options do |t|
      t.string :content
      t.references :poll, null: false, foreign_key: true
      t.integer :votes

      t.timestamps
    end
  end
end
