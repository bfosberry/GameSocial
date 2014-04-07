unless defined? SECRETS
  SECRETS={}
  SECRETS['steam_api_key'] = ENV['STEAM_API_KEY']
  SECRETS['smtp_username'] = ENV['SMTP_USERNAME']
  SECRETS['smtp_password'] = ENV['SMTP_PASSWORD']
  SECRETS['smtp_server'] = ENV['SMTP_SERVER']
  SECRETS['smtp_port'] = ENV['SMTP_PORT']

  secret_file = "#{Rails.root}/config/secret.yml"
  if File.exists?(secret_file)
    SECRETS = YAML.load_file("#{Rails.root}/config/secret.yml")[Rails.env]
  end
end


