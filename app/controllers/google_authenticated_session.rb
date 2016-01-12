get '/login/google' do
  # set referrer in the session for future use
  session[:referrer] = request.referrer
  # redirect browser to google for login / authorization
  redirect Octokit::Client.new.authorize_url(ENV['GOOGLE_CLIENT_ID'], :scope => 'user:email')
end

get '/auth/google/callback' do
  # set unique session code from the server for communication with google when requesting token
  session_code = request.env['rack.request.query_hash']['code']
  # access token is a security measure to prevent forged authorization requests
  result = Octokit.exchange_code_for_token(session_code, ENV['GOOGLE_CLIENT_ID'], ENV['google_CLIENT_SECRET'])
  access_token = result[:access_token]

  google_user_data = get_google_user_data(access_token)

  # if the auth entry doesn't exist, create it

  # if there's a user in the db with the currently logged in google username, return that user
  # otherwise show the registration form with the google info prefilled in the registration form
  auth =  Auth.find_by_unique_id(google_user_data.login)
  if auth.nil?
    @username = google_user_data.login
    @full_name = google_user_data.name
    @email = google_user_data.private_emails.first
    @avatar_url = google_user_data.avatar_url
    erb :"user/google_new"
  else
    session[:user_id] = auth.user.id
    redirect session[:referrer]
  end
end
