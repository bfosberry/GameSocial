class Post < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true

  belongs_to :postable, :polymorphic => true
end
