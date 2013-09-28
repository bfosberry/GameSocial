class Alert < ActiveRecord::Base
  belongs_to :alert_schedule
  delegate :user, :to => :alert_schedule
  serialize :payload
end
