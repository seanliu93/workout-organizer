class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.string :name
      t.boolean :active
      t.integer :user_id
    end
  end
end
