class AlertCondition < ActiveRecord::Base
  belongs_to :alert_schedule
  serialize :value

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
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ]
  end

  def parsed_value
    if condition_type == "times"
      {
        "start_time" => parse_time(value, "start_time"),
        "end_time" => parse_time(value, "end_time")
      }
    else
      value[condition_type].delete_if{ |x| x.empty? } if value
    end
  end

  def parse_time(t, name)
    hour_name = "#{name}(4i)"
    min_name = "#{name}(5i)"
    "#{t[hour_name]}:#{t[min_name]}"
  end
end
