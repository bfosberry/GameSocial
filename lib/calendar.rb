require 'google_calendar'

class Calendar
  CALENDAR_ID = ENV['CALENDAR_ID']
  APP_NAME = "GameSocial"

  attr_accessor :object

  def initialize(object)
    self.object = object
  end

  def default_reminders
  	 [{method: 'email', minutes: 10}, 
  	  {method: 'alert', minutes: 5}]
  end

  def create_event
   	return if event
   	@event = Google::Event.new({:reminders => default_reminders, 
   		                          :send_event_notification => true, 
   		                          :calendar => calendar})
  	update_event
  end

  def update_event
  	return unless event
    event.calendar = calendar
  	event.title = object.name
  	event.start_time = object.start_time
  	event.end_time = object.end_time
  	event.content = object.description
  	event.attendees = build_attendees
  	event.where = object.location
  	event.save
  	object.update_attribute(:uid, event.id) unless object.uid
    event
  end

  def build_attendees
  	users_with_email = object.users.select {|u| u.email }
  	users_with_email.map do |u|
  		relation = 'http://schemas.google.com/g/2005#event.attendee'
  		#if u == object.user
  		#  relation = 'http://schemas.google.com/g/2005#event.organizer'
  		#end
  		{ :email => u.email, 
  		  :name => u.name,
  		  :relation => relation,
  		  :required => false }
  	end
  end

  def event
    unless @event
      if object.uid
        evs = calendar.find_event_by_id(object.uid) 
        @event = evs.first if evs
      end
    end
    @event
  end

  def delete_event
  	ev = event
  	calendar.delete_event(ev) if ev
  	object.update_attribute(:uid, nil)
  	@event = nil
  end

  def calendar 
  	@calendar ||= initialize_calendar
  end

  def initialize_calendar
  	Google::Calendar.new(:client_id => ENV['CLIENT_ID'],
                         :client_secret => ENV['CLIENT_SECRET'],
                         :calendar => ENV['CALENDAR_ID'],
                         :redirect_url => "urn:ietf:wg:oauth:2.0:oob")
  end
end
