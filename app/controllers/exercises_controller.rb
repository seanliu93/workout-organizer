class ExercisesController < ApplicationController 

  get "/exercises/new" do
    if logged_in?
      if session[:count] != nil
        @count = session[:count].to_i
      else
        @count = 1
      end
      erb :'exercises/new'
    else
      redirect '/login'
    end
  end

  get "/exercises/new/:id" do
    #binding.pry
    if logged_in?
      if session[:count] != nil
        @count = session[:count].to_i
      else
        @count = 1
      end
      @error_msg = params[:error]
      @workout = Workout.find(params[:id])
      erb :'exercises/new'
    else
      redirect '/login'
    end
  end

  get "/exercises/:id/edit" do
    #binding.pry
    @exercise = Exercise.find(params[:id])
    @error_msg = params[:error]
    @workout_id = params[:workout_id]
    erb :'exercises/edit'
  end

  get "/exercises/:id/delete" do
      Exercise.find(params[:id]).destroy
      redirect "/workouts/#{params[:workout_id]}/edit"
  end

  get "/exercises/:id/unlink" do
    # if user clicked (remove from workout), remove association but do not delete exercise
    @workout = Workout.find(params[:workout_id])
    temp = @workout.exercise_ids
    temp.delete(params[:id].to_i)
    @workout.exercise_ids = temp
    @workout.save
    redirect "/workouts/#{params[:workout_id]}/edit"
  end

  patch "/exercises/:id" do
    if params[:name] == "" || params[:num_sets] == "" || params[:num_reps] == ""
      redirect "/exercises/#{params[:id]}/edit?error=Field(s) cannot be left blank"
    end
    @exercise = Exercise.find(params[:id])
    @exercise.name = params[:name]
    @exercise.num_sets = params[:num_sets]
    @exercise.num_reps = params[:num_reps]
    @exercise.save
    redirect "/workouts/#{params[:workout_id]}/edit"
  end
end
