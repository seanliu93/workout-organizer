class UsersController < ApplicationController 

  get '/signup' do
    if !logged_in?
      @error_msg = params[:error]
      erb :'users/new'
    else
      redirect to '/workouts'
    end
  end

  post '/signup' do 
    if params[:username] == "" || params[:password] == ""
      redirect to '/signup?error=Invalid input'
    else
      @user = User.find_by(:username => params[:username])
      if @user
        redirect to '/signup?error=Username already taken'
      end
      @user = User.create(:username => params[:username], :password => params[:password])
      session[:user_id] = @user.id
      redirect '/workouts'
    end
  end

  get '/login' do 
    @error_msg = params[:error]
    if !logged_in?
      erb :'users/login'
    else
      redirect '/workouts'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/workouts"
    else
      redirect to "/login?error=Username or password incorrect"
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end

end
