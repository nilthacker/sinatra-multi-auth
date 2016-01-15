
helpers do

  LinkedIn.configure do |config|
    config.client_id = ENV['LINKEDIN_CLIENT_ID']
    config.client_secret = ENV['LINKEDIN_CLIENT_SECRET']
    config.redirect_uri = linkedin_auth_callback_full_url
  end

  def linkedin_auth_callback_path
    '/auth/linkedin/callback'
  end

  def linkedin_auth_callback_full_url
    "#{request.base_url}#{linkedin_auth_callback_path}"
  end
end
