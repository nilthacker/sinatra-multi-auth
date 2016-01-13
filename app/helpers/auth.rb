helpers do
  def authenticated?
    return !session[:user_id].nil?
  end

  def current_user
    return User.find(session[:user_id]) if authenticated?
  end

  def existing_user(email)
    User.find_by_email(email)
  end

  def local_user?(email)
    User.find_by_email(email).password_hash.nil?
  end

end
