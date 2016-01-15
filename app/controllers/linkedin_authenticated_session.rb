get '/login/linkedin' do
  # set referrer in the session for future use
  session[:referrer] = request.referrer
  # redirect browser to linkedin for login / authorization
  linkedin_oauth = LinkedIn:OAuth2.new
  redirect linkedin_oauth.auth_code_url
end

get '/auth/linkedin/callback' do
  # set unique session code from the server for communication with linkedin when requesting token
  session_code = request.env['rack.request.query_hash']['code']
  # access token is a security measure to prevent forged authorization requests
  access_token = LinkedIn::OAuth2.new.get_access_token(session_code)

  linkedin_user_data = LinkedIn::API.new(access_token)

  # if the auth entry doesn't exist, create it

  # if there's a user in the db with the currently logged in linkedin username, return that user
  # otherwise show the registration form with the linkedin info prefilled in the registration form
  auth =  Auth.find_by_unique_id(linkedin_user_data.id)
  if auth.nil?
    @username = linkedin_user_data.id
    @full_name = linkedin_user_data.formatted-name
    @email = linkedin_user_data.email-address
    @avatar_url = linkedin_user_data.picture-url
    erb :"user/linkedin_new"
  else
    session[:user_id] = auth.user.id
    redirect session[:referrer]
  end
end
