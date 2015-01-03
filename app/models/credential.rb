class Credential < ActiveRecord::Base
  belongs_to :user

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |cred|
      cred.provider = auth["provider"]
      cred.uid = auth["uid"]
      cred.image_url = auth["info"]["image"]
      cred.name = auth["info"]["name"]
      if cred.is_google?
        cred.email = auth["info"]["email"]
        cred.profile_url = auth["extra"]["raw_info"]["profile"]
        cred.refresh_token = auth["credentials"]["token"]
        cred.token_expiry = auth["credentials"]["expires_at"]
      elsif cred.is_steam?
        cred.nickname = auth["info"]["nickname"]
        cred.profile_url = auth["extra"]["raw_info"]["profileurl"]
      end  
    end
  end

  def is_steam?
    provider == "steam"
  end

  def is_google?
    provider == "google_oauth2"
  end
end
