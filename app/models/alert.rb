require 'workers/alert_worker'
class Alert < ActiveRecord::Base
  belongs_to :alert_schedule
  delegate :user, :to => :alert_schedule, :allow_nil => true
  delegate :name, :to => :alert_schedule, :prefix => true, :allow_nil => true
  delegate :game_name, :to => :payload, :allow_nil => true
  delegate :user_name, :to => :payload, :allow_nil => true
  serialize :payload, Hash

  after_create :deliver_alert

  def delivered?
    delivered_at.present?
  end

  def deliver_alert
    user.notify_websocket(self)
    Workers::AlertWorker.perform_async(id)
  end
end
