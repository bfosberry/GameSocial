module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    user.activate
    user.refresh_data_sync
  end

  def sign_out
    cookies.permanent[:remember_token] = nil
  end

  def signed_in?
    !current_user.nil?
  end

  def is_admin?
    signed_in? && current_user.admin?
  end

  def current_user
    @current_user ||= User.find_by_remember_token(remember_token) unless remember_token.blank?
  end

  def remember_token
    cookies.permanent[:remember_token]
  end
end
