class Event < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  has_many :posts, as: :postable
end
