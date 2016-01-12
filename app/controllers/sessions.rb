get '/login' do
  if authenticated?
    @user = User.find(session[:user_id])
    redirect "/users/#{@user.id}", notice: "Thank you for logging in."
  else
    erb :login
  end
end


post '/login' do
  @user = User.find_by_email(params[:email])
  if @user && @user.authenticate(params[:password_plaintext])
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
  else
    session.delete(:user_id)
    redirect '/login', error: "Please check your email address and password and try again."
  end
end

get '/logout' do
  session[:referrer] = request.referrer
  session.delete(:user_id)
  redirect session[:referrer], notice: "You have been logged out."
end
