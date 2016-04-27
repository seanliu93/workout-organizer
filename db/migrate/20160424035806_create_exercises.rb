class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
       t.string :name
       t.integer :num_sets
       t.integer :num_reps
    end
  end
end
