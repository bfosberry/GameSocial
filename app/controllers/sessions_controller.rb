class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def create
    cred = Credential.from_omniauth(env['omniauth.auth'])
    user = current_user || cred.user || User.new
    user.merge_credential(cred)
    sign_in user
    return_to = session.delete(:return_to) || root_url
    redirect_to return_to, notice: "Signed in."
  end

  def destroy
    sign_out
    redirect_to root_url, notice: "Signed out."
  end
end
