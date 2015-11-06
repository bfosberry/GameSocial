class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.  
  skip_before_filter :verify_authenticity_token  
  helper_method :current_user

  include SessionsHelper

  def enforce_login
    unless signed_in?
      session[:return_to] = request.fullpath
      redirect_to "/auth/steam"
    end
  end

  def enforce_admin
    send_unauthorized unless is_admin?
  end

  def enforce_ownership(object)
    send_unauthorized unless validate_ownership(object)
  end

  def enforce_visibility(object)
    send_unauthorized unless is_visible?(object)
  end

  def spoof_login
    user = User.find_by_remember_token(params[:auth_token])
    sign_in user if user
  end

  def send_unauthorized
    render :text => "You are not allowed to view this resource.", :status => :unauthorized
  end
  
  private
    def validate_ownership(object)
      signed_in? && (is_admin? || (object == current_user || object.user == current_user))
    end

    def all_owned(model)
      if model.column_names.include? "user_id"
        model.where(:user_id => current_user.id) 
      else 
        model
      end
    end

    def all_visible(model)
      ids = model.select{|o| o.is_visible_to?(current_user)}.map{|o| o.id}  
      model.where(id: ids)
    end

    def is_visible?(object)
       if object.respond_to?(:is_visible_to?)
         object.is_visible_to?(current_user)
       else
        false
      end
    end
end
