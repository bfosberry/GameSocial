require 'ri_cal'
class Ical
  def self.ical_from_collection(objects)
    RiCal.Calendar do |cal|
      objects.each do |o|
        cal.event do |event|
          event.summary     = o.name 
          event.description = o.description
          event.dtstart     = o.start_time
          event.dtend       = o.end_time
          event.location    = o.location if o.location
          event.organizer   = "MAILTO:#{o.user_email}" if o.user_email
          o.users.each {|u| event.add_attendee("MAILTO:#{u.email}") if u.email}
          event.alarm do |a|
            a.description = "5 minutes"
            a.trigger = "-PT5M"
            a.action  = "DISPLAY"
          end
        end
      end
    end
  end
end
