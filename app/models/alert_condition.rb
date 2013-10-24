class AlertCondition < ActiveRecord::Base
  belongs_to :alert_schedule
  serialize :value
  delegate :user, :to => :alert_schedule

  def self.condition_types
  	[
      :games,
      :users,
      :days,
      :times
  	]
  end

  def self.condition_for(type, alert_schedule)
  	where({:condition_type => type, :alert_schedule_id => alert_schedule.id}).first
  end

  def self.days_of_the_week
    [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ]
  end

  def parsed_value
    if condition_type == "times"
      {
        :start_time => parse_time(value, "start_time"),
        :end_time => parse_time(value, "end_time")
      }
    else
      value[condition_type].delete_if{ |x| x.empty? } if value
    end
  end

  def parse_time(t, name)
    t ? t[name] : default_time(name)
  end

  def default_time(name)
    name == "start_time" ? "00:00" : "23:59" 
  end

  def verify(game_location)
    puts "Checking #{condition_type}"
    if condition_type.to_sym == :games
      included?(game_location.game_id)
    elsif condition_type.to_sym == :users
      included?(game_location.user_id)
    elsif condition_type.to_sym == :days
      dow = AlertCondition.days_of_the_week[DateTime.now.wday]
      included?(dow)
    elsif condition_type.to_sym == :times
      now = DateTime.now
      val = parsed_value
      start_time = adjusted_time(val[:start_time])
      end_time = adjusted_time(val[:end_time])
      
      start_time < now && now <= end_time
    end    
  end

  private 
    def included?(value)
      parsed_value.include?(value.to_s)
    end

    def adjusted_time(time_str)
      time_arr = time_str.split(":")
      DateTime.now.change({:hour => time_arr[0].to_i , :min => time_arr[1].to_i, :sec => 0 })
    end
end
