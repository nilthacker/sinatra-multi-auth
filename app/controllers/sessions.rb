get '/sessions/new' do
  if authenticated?
    @user = User.find(session[:user_id])
    redirect "/users/#{@user.id}", notice: "Thank you for logging in."
  else
    erb :login, layout: false
  end
end

post '/sessions/new' do
  @user = User.find_by_email(params[:email])
  if @user && @user.authenticate(params[:password_plaintext])
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
  else
    session.delete(:user_id)
    redirect '/sessions/new', error: "Please check your email address and password and try again."
  end
end

get '/logout' do
  session.delete(:user_id)
  redirect '/', notice: "You have been logged out."
end