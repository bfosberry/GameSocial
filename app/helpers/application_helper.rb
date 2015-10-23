module ApplicationHelper
  def calendar_path(object_path)
    "#{object_path}.ics?auth_token=#{current_user.remember_token}&noCache"
  end
end
