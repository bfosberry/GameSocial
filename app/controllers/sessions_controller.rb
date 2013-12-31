class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    user.import
    sign_in user.reload
    redirect_to root_url, notice: "Signed in."
  end

  def destroy
    sign_out
    redirect_to root_url, notice: "Signed out."
  end
end
