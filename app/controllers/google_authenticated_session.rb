get '/login/google' do
  # set referrer in the session for future use
  session[:referrer] = request.referrer
  # redirect browser to google for login / authorization
  redirect auth_authorize_link
end

get '/auth/google/callback' do
  google_user_data = auth_process_code(params[:code])

  @username = google_user_data["sub"]
  @full_name = google_user_data["name"]
  @email = google_user_data["email"]
  @avatar_url = google_user_data["picture"]

  # does the google user email address exist in the users table?
  matching_email = User.find_by_email(@email)

  # if there's a user in the db with the currently logged in google username, return that user
  # otherwise show the registration form with the google info prefilled in the registration form
  auth =  Auth.find_by_unique_id(google_user_data["sub"])

  # if the google user email exists in the users table and there's no auth entry for it, show the link form
  if matching_email && auth.nil?
    @service = "google"
    erb :"/user/link_account"
  elsif auth.nil?
    erb :"user/google_new"
  else
    session[:user_id] = auth.user.id
    redirect session[:referrer]
  end
end
