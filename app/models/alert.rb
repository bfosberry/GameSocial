require 'workers/alert_worker'
class Alert < ActiveRecord::Base
  belongs_to :alert_schedule
  delegate :user, :to => :alert_schedule
  delegate :name, :to => :alert_schedule, :prefix => true
  serialize :payload

  after_create :deliver_alert

  def delivered?
    !delivered_at.nil?
  end

  def deliver_alert
  	w = Workers::AlertWorker.new
  	w.perform(id)
  end
end
