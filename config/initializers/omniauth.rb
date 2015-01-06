Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :steam, ENV['STEAM_API_KEY']
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           {
           	 scope: "https://www.googleapis.com/auth/userinfo.email,
                     https://www.googleapis.com/auth/userinfo.profile"
           }

  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           {
             name: "google_admin",
             scope: "https://www.googleapis.com/auth/userinfo.email,
                     https://www.googleapis.com/auth/userinfo.profile,
                     https://www.googleapis.com/auth/calendar"
           }
end