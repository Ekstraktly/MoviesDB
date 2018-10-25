class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.belongs_to :genre, index: true, foreign_key: true
      t.string :title
      t.integer :year
      t.string :overview
      t.float :score

      t.timestamps null: false
    end
  end
end
