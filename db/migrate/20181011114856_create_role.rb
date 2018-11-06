class CreateRole < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.belongs_to :actor, index: true, foreign_key: true
      t.belongs_to :movie, index: true, foreign_key: true
      t.string :name
      t.timestamps null: false
    end
  end
end
