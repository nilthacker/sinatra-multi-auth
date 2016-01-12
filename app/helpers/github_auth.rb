def get_github_user_data(access_token)

  # set up github oauth client with application id & secret
  client = Octokit::Client.new \
  :client_id => ENV['GITHUB_CLIENT_ID'],
  :client_secret => ENV['GITHUB_CLIENT_SECRET']

  # make sure the token is still valid
  begin
    client.check_application_authorization access_token
  rescue => e
    # request didn't succeed because the token was revoked so we
    # invalidate the token stored in the session and render the
    # index page so that the user can start the OAuth flow again
    session[:user_id] = nil
    redirect '/login/github'
  end

  # if valid, fetch the user's data
  client = Octokit::Client.new :access_token => access_token
  user_data = client.user

  # find all emails and add it to user_data
  if client.scopes(access_token).include? 'user:email'
    user_data['private_emails'] = client.emails.map { |m| m[:email] }
  end

  return user_data

end
