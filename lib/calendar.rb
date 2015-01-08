require 'google_calendar'

class Calendar
  APP_NAME = "GameSocial"
  REFRESH_TOKEN_KEY = "GOOGLE_REFRESH_TOKEN_#{Rails.env}"

  def self.set_refresh_token(token)
    Redis.current.set(REFRESH_TOKEN_KEY, token)
  end

  def self.refresh_token
    Redis.current.get(REFRESH_TOKEN_KEY)
  end

  attr_accessor :object

  def initialize(object)
    self.object = object
  end

  def default_reminders
    { 'useDefault'  => false,
      'overrides' => [{'minutes' => 5, 'method' => "popup"},
                      {'minutes' => 10, 'method' => "email"}]}
  end

  def create_event
   	return if event
    @event = Google::Event.new({:send_event_notification => true,
   		                          :calendar => calendar})
  	update_event
  end

  def update_event
  	return unless event
    event.calendar = calendar
  	event.title = object.name
  	event.start_time = object.start_time
  	event.end_time = object.end_time
    event.description = object.description if object.description
  	event.attendees = build_attendees
    event.location = object.location if object.location
    event.reminders = default_reminders
    event.save
  	object.update_attribute(:uid, event.id) unless object.uid
    event
  end

  def build_attendees
  	users_with_email = object.users.select {|u| u.email }
  	users_with_email.map do |u|
      { 'email' => u.email,
        'displayName' => u.name,
        'responseStatus' => "tentative" }
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
    Google::Calendar.new(:client_id => ENV['GOOGLE_CLIENT_ID'],
                         :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                         :calendar => ENV['GOOGLE_CALENDAR_ID'],
                         :redirect_url => "urn:ietf:wg:oauth:2.0:oob",
                         :refresh_token  => Calendar.refresh_token)
  end
end
