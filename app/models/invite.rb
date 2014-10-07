class Invite
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :email, :game_event, :event, :user

  def deliver
    verify_email
    return unless email
    if game_event
      InviteMailer.invite_game_event_email(self).deliver
    elsif event
      InviteMailer.invite_event_email(self).deliver
    end
  end

  def verify_email
    u = User.find_by_name(email)
    self.email = u.email if u
  end

  def subject
    "You've been invited to #{object.name}"
  end

  def object
    event || game_event
  end

  def initialize(hsh = {})
    hsh.each do |key, value|
      self.send(:"#{key}=", value)
    end
  end
end