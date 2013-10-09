class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.  
  skip_before_filter :verify_authenticity_token  
  helper_method :current_user

  include SessionsHelper

  def enforce_login
    unless signed_in?
      session[:return_to] ||= request.referer
      redirect_to root_url
    end
  end

  def enforce_admin
    send_unauthorized unless is_admin?
  end

  def enforce_ownership(object)
    send_unauthorized unless validate_ownership(object)
  end

  def send_unauthorized
    render :text => "You are not allowed to view this resource.", :status => :unauthorized
  end
  
  private

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def validate_ownership(object)
      signed_in? && (is_admin? || (object == current_user || object.user == current_user))
    end

    def all_owned(model)
      model.all.select {|m| m.user == current_user }
    end

end
