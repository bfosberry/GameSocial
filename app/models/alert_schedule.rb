class AlertSchedule < ActiveRecord::Base
  belongs_to :user
  has_many :alert_conditions, dependent: :destroy
  has_many :alerts

  after_create :generate_conditions

  has_many :alerting_users
  has_many :users, through: :alerting_users

  accepts_nested_attributes_for :alert_conditions, :allow_destroy => true

  delegate :name, :to => :user, :prefix => true, :allow_nil => true

  def generate_conditions
  	AlertCondition.condition_types.each {|t| generate_condition(t) }
    condition_for(:users).parsed_value.each do |user_id|
      user = User.find(user_id)
      alerting_users << user if user
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
  end
end
