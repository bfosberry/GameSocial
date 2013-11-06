# Load the Rails application.
SECRETS = YAML.load_file("#{Rails.root}/config/secret.yml")[Rails.env]
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
GameSocial::Application.initialize!
