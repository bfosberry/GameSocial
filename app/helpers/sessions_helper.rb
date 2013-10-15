module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
  end

  def sign_out
    cookies.permanent[:remember_token] = nil
  end

  def signed_in?
    puts "Checking signed in"
    puts current_user
    !current_user.nil?
  end

  def is_admin?
    signed_in? && current_user.admin?
  end

  def current_user
    puts remember_token
    @current_user ||= User.find_by_remember_token(remember_token) if remember_token
  end

  def remember_token
    puts "token is #{cookies.permanent[:remember_token]}"
    cookies.permanent[:remember_token]
  end
end
