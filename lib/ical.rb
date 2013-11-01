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
        end
      end
    end
  end
end
