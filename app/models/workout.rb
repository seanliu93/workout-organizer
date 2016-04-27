class Workout < ActiveRecord::Base
  belongs_to :user
  has_many :workout_exercises
  has_many :exercises, through: :workout_exercises

  def self.valid_params?(params)
    return !params[:name].empty? && !params[:capacity].empty?
  end

  def become_active
    Workout.all.each do |workout|
      workout.active = false
      workout.save
    end
    self.active = true
    self.save
  end
end
