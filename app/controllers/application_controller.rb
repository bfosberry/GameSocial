class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.  
  skip_before_filter :verify_authenticity_token  
  helper_method :current_user

  include SessionsHelper

  def enforce_admin
    redirect_to root_url unless is_admin?
  end

  def enforce_login
    unless signed_in?
      session[:return_to] ||= request.referer
      redirect_to root_url
    end
  end
  
  private

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end
end
