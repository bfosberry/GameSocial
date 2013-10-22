class AlertSchedule < ActiveRecord::Base
  belongs_to :user
  has_many :alert_conditions, dependent: :destroy
  has_many :alerts

  after_commit :generate_conditions

  has_many :alerting_users, dependent: :destroy
  has_many :users, through: :alerting_users

  accepts_nested_attributes_for :alert_conditions, :allow_destroy => true

  delegate :name, :to => :user, :prefix => true, :allow_nil => true

  def generate_conditions
  	AlertCondition.condition_types.each {|t| generate_condition(t) }
    reload
    condition_for(:users).parsed_value.each do |user_id|
      user = User.find(user_id)
      if user
        users << user unless users.include?(user)
      end
    end
  end

  def generate_condition(type)
  	 AlertCondition.find_or_create_by_condition_type_and_alert_schedule_id({
      :alert_schedule_id => id,
      :condition_type => type
  	})
  end

  def condition_for(type)
    AlertCondition.condition_for(type, self)
  end

  def alert(game_location)
    if verify_alert_schedule(game_location)
      existing_alert = user.alerts.select {|a| a.payload == game_location }.first 
      unless existing_alert
        alert = Alert.new({
          :alert_schedule => self,
          :title => game_location.location_title,
          :payload => game_location,
          :description => game_location.location_body
        })
        alert.save
      end
    end
  end

  def verify_alert_schedule(game_location)
    puts "Checking #{name}"
    alert_conditions.map {|c| c.verify(game_location) }.all?
  end
end
