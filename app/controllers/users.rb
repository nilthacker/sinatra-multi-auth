get '/users/new' do
  if authenticated?
    @user = User.find(session[:user_id])
    redirect "/users/#{@user.id}", notice: "You're already logged in. Why register a new account?"
  else
    erb :"user/new", layout: false
  end
end

post '/users/new' do
  if params[:password_plaintext1] != params[:password_plaintext2]
    redirect '/users/new', error: "Both passwords must match."
  else
    @user = User.new(full_name: params[:full_name], email: params[:email])
    @user.password = params[:password_plaintext1]
    if @user.save
      session[:user_id] = @user.id
      redirect "/users/#{@user.id}", notice: "Registration successful."
    else
      @errors = @user.errors.full_messages
      erb :"user/new"
    end
  end
end

post '/users/:service/new' do
    if (user = existing_user(params[:email]))
      Auth.create(user_id: user.id, service: params[:service], unique_id: params[:unique_id])
      session[:user_id] = user.id
      redirect "/users/#{user.id}", notice: "#{params[:service].capitalize} account successfully linked."
    else
      @user = User.new(full_name: params[:full_name], email: params[:email], avatar_url: params[:avatar_url])
      if @user.save
        Auth.create(user_id: @user.id, service: params[:service], unique_id: params[:unique_id])
        session[:user_id] = @user.id
        redirect "/users/#{@user.id}", notice: "Registration successful."
      else
        @errors = @user.errors.full_messages
        redirect "/login/#{params[:service]}", error: @errors.join(' & ')
      end
    end

end

get '/users/:user_id' do
  @current_user = current_user if authenticated?
  @profile_owner = User.find(params[:user_id])
  redirect '/' unless @profile_owner
  @not_a_local_user = local_user?(@current_user.email) if @current_user
  erb :"user/profile"
end

get '/users/:user_id/createpassword' do
  @current_user = current_user if authenticated?
  @profile_owner = User.find(params[:user_id])
  if @current_user.id === @profile_owner.id
    erb :"user/_add_password", layout: false
  else
    redirect 'https://www.youtube.com/embed/VFZIiWmKBMs?autoplay=1'
  end
end

post '/users/:user_id/createpassword' do
  if params[:password_plaintext1] != params[:password_plaintext2]
    redirect "/users/#{params[:user_id]}", error: "Your passwords don't match, try again"
  else
    @current_user = current_user if authenticated?
    @profile_owner = User.find(params[:user_id])
    if @current_user.id === @profile_owner.id
      @current_user.password = params[:password_plaintext1]
      @current_user.save
    end
    redirect "/users/#{params[:user_id]}", notice: "Your password has been added"
  end

end
