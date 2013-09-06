class SessionsController < ApplicationController
 skip_before_filter :verify_authenticity_token  
  def create
   user = User.from_omniauth(env['omniauth.auth'])
   session[:user_id] = user.id
   redirect_to root_url, notice: "Signed in."
  end


end
