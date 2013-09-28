class AlertingUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :alert_schedule
end
