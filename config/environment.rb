# Load the Rails application.
require File.expand_path('../application', __FILE__)
SECRETS = YAML.load_file("#{Rails.root}/config/secret.yml")[Rails.env]

# Initialize the Rails application.
GameSocial::Application.initialize!
