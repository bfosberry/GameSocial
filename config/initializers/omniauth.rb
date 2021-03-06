Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :steam, ENV['STEAM_API_KEY']
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           {
             access_type: 'offline',
           	 scope: "https://www.googleapis.com/auth/userinfo.email,
                     https://www.googleapis.com/auth/userinfo.profile"
           }
end