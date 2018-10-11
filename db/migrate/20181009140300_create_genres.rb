class CreateGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :genres do |t|
      t.string :name, null: false, unique: true
      t.timestamps null: false
    end

    add_index :genres, :name, unique: true
  end
end
