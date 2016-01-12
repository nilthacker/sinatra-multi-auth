helpers do
  def authenticated?
    return !session[:user_id].nil?
  end

  def current_user
    return User.find(session[:user_id]) if authenticated?
  end
end