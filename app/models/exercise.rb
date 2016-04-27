class Exercise < ActiveRecord::Base
  has_many :workout_exercises
  has_many :workouts, through: :workout_exercises

  def self.valid_params?(params)
    return !params[:name].empty? && !params[:manufacturer].empty?
  end

  def self.not_linked_to(workout_id)
    workout = Workout.find(workout_id)
    exercises = []
    Exercise.all.each do |exercise|
      if !workout.exercise_ids.include?(exercise.id)
        exercises << exercise
      end
    end
    exercises
  end

end
