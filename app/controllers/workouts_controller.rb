class WorkoutsController < ApplicationController

  get '/workouts' do
    if logged_in?
      @user = User.find(session[:user_id])
      @workouts = @user.workouts
      erb :'workouts/index'
    else
      redirect '/login'
    end
  end

  post '/workouts/:id' do
    @workout = Workout.find(params[:id])
    counter = 1
    while (params["name_#{counter.to_s}"])
      name = params["name_#{counter.to_s}"]
      num_sets = params["num_sets_#{counter.to_s}"]
      num_reps = params["num_reps_#{counter.to_s}"]
      # error checking
      if name == "" || num_sets == "" || num_reps == ""
        redirect "/exercises/new/#{@workout.id}?error=Field(s) cannot be left blank"
      elsif Exercise.find_by(name: name) != nil
        redirect "/exercises/new/#{@workout.id}?error=Exercise #{name} already exists!"
      end

      # while the parameter exists, create the new exercise with parameters and increment counter
      if Exercise.find_by(name: name)
        redirect "/exercises/new/#{@workout.id}?error=#{name} already exists"
      else
      @exercise = Exercise.create(name: params["name_#{counter.to_s}"], 
        num_sets: params["num_sets_#{counter.to_s}"], 
        num_reps: params["num_reps_#{counter.to_s}"])
      @workout.exercise_ids = (@workout.exercise_ids << @exercise.id)
      @workout.save
      end
      counter += 1
    end
    redirect "/workouts/#{@workout.id}"
  end
    
  post '/workouts' do
    if logged_in?
      if Workout.find_by(name: params[:name])
        redirect '/workouts/new?error=Workout name already exists'
      else
        # create the workout and link to checked exercises
        @workout = Workout.create(name: params[:name], user_id: session[:user_id], active: false)
        if params["workout"]
          @workout.exercise_ids = params["workout"]["exercise_ids"]
        end
        @workout.save
        # add number of exercises and redirect to new exercise form
        if params["exercise_count"] != ""
          session[:count] = params["exercise_count"]
          redirect "/exercises/new/#{@workout.id.to_s}"
        else
        redirect "/workouts/#{@workout.id.to_s}"
        end
      end
    end
  end

  patch '/workouts/:id' do
    if logged_in?
      # find workout and link to checked exercises
      @workout = Workout.find(params[:id])
      @workout.name = params["name"]


      # if there were checked boxes..
      if params["workout"]
        @workout.exercise_ids.each do |id|
          params["workout"]["exercise_ids"] << id
        end
        @workout.exercise_ids = params["workout"]["exercise_ids"]
      end
      if params["active"]
        @workout.become_active
      end
      @workout.save
      # add number of exercises and redirect to new exercise form
      if params["exercise_count"] != ""
        binding.pry
        session[:count] = params["exercise_count"]
        redirect "/exercises/new/#{@workout.id.to_s}"
      else
        redirect "/workouts/#{@workout.id.to_s}"
      end
    end
  end

  get '/workouts/new' do
    if logged_in?
      @error_msg = params[:error]
      erb :'workouts/new'
    else
      redirect "/login"
    end
  end

  get '/workouts/:id' do
    if logged_in?
      @workout = Workout.find(params[:id])
      erb :'workouts/show'
    else
      redirect "/login"
    end
  end

  get '/workouts/:id/edit' do
    if logged_in?
      @workout = Workout.find(params[:id])
      erb :'workouts/edit'
    else
      redirect "/login"
    end
  end

  get '/workouts/:id/delete' do
    if logged_in?
      Workout.find(params[:id]).destroy
      redirect "/workouts"
    else
      redirect "/login"
    end
  end
end
