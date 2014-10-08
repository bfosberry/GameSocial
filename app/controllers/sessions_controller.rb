class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    user.refresh_data_sync
    sign_in user.reload
    redirect_to session.delete(:return_to), notice: "Signed in."
  end

  def destroy
    sign_out
    redirect_to root_url, notice: "Signed out."
  end
end
