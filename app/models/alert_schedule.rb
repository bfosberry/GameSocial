class AlertSchedule < ActiveRecord::Base
  belongs_to :user
  has_many :alert_conditions, dependent: :destroy
  has_many :alerts

  after_create :generate_conditions

  accepts_nested_attributes_for :alert_conditions, :allow_destroy => true

  delegate :name, :to => :user, :prefix => true, :allow_nil => true

  def generate_conditions
  	AlertCondition.condition_types.each {|t| generate_condition(t) }
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
end
