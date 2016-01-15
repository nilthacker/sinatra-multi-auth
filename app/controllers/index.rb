get '/' do
  @user = current_user
  erb :index
end
