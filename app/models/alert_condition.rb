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
end
