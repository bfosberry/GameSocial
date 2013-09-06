Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :steam, 'A67D7BFF425F5340678E8F8BD8BE114D'
end
