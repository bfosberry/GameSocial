module ApplicationHelper
  def calendar_path(object_path)
  	token = current_user ? current_user.remember_token : ''
    "#{object_path}.ics?auth_token=#{token}&noCache"
  end
end
