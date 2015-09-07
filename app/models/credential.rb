class Credential < ActiveRecord::Base
  belongs_to :user

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |cred|
      create_from_omniauth(auth, cred)
    end
  end

  def self.create_from_omniauth(auth, cred)
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

  def is_steam?
    provider == "steam"
  end

  def is_google?
    provider == "google_oauth2"
  end
end
