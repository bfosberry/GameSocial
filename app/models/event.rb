class Event < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
end
