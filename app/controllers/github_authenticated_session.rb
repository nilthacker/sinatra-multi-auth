get '/login/github' do
  # set referrer in the session for future use
  session[:referrer] = request.referrer
  # redirect browser to github for login / authorization
  redirect Octokit::Client.new.authorize_url(CLIENT_ID, :scope => 'user:email')
end

get '/auth/github/callback' do
  # set unique session code from the server for communication with Github when requesting token
  session_code = request.env['rack.request.query_hash']['code']
  # access token is a security measure to prevent forged authorization requests
  result = Octokit.exchange_code_for_token(session_code, CLIENT_ID, CLIENT_SECRET)
  access_token = result[:access_token]

  github_user_data = get_github_user_data(access_token)

  # if there's a user in the db with the currently logged in github username, return that user
  # otherwise show the registration form with the github info prefilled in the registration form
  user =  Auths.find_by_unique_id(github_user_data.login).user
  if user.nil?
    @fullname = github_user_data.name
    @email = github_user_data.private_emails.first
    @avatar_url = github_user_data.avatar_url
    erb :"user/github_new"
  else
    session[:user_id] = user.id
    redirect session[:referrer]
  end
end
