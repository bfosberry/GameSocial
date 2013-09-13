class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to games_path, notice: "Signed in."
  end

  def destroy
    session[:user_id] = nil
    redirect_to games_path, notice: "Signed out."
  end
end
