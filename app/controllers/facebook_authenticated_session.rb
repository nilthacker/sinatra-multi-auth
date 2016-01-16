get '/login/facebook' do
  # set referrer in the session for future use
  session[:referrer] = request.referrer
  # redirect browser to linkedin for login / authorization
  LinkedIn.config.redirect_uri = linkedin_auth_callback_full_url
  LinkedIn.config.scope = ['r_basicprofile','r_emailaddress'].join(' ')
  linkedin_oauth = LinkedIn::OAuth2.new
  redirect linkedin_oauth.auth_code_url
end

get '/auth/facebook/callback' do
  OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK__CLIENT_SECRET']
  end
  # set unique session code from the server for communication with linkedin when requesting token
  session_code = request.env['rack.request.query_hash']['code']
  # access token is a security measure to prevent forged authorization requests
  LinkedIn.config.redirect_uri = linkedin_auth_callback_full_url
  LinkedIn.config.scope = ['r_basicprofile','r_emailaddress'].join(' ')
  access_token = LinkedIn::OAuth2.new.get_access_token(session_code)

  api = LinkedIn::API.new(access_token)
  linkedin_user_data = api.profile
  linkedin_user_email = api.profile(fields: ["email-address"])
  linkedin_user_avatar = api.profile(fields: ["picture-url"])
  # if the auth entry doesn't exist, create it
  # if there's a user in the db with the currently logged in linkedin username, return that user
  # otherwise show the registration form with the linkedin info prefilled in the registration form
  auth =  Auth.find_by_unique_id(linkedin_user_data.id)
  if auth.nil?
    @username = linkedin_user_data.id
    @full_name = [linkedin_user_data.first_name, linkedin_user_data.last_name].join(' ')
    @email = linkedin_user_email.email_address
    @avatar_url = linkedin_user_avatar.picture_url
    erb :"user/linkedin_new"
  else
    session[:user_id] = auth.user.id
    redirect session[:referrer]
  end
end
