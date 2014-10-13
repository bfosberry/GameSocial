class InviteMailer < ActionMailer::Base
  default from: "invitations@cloud1001.co"

  def invite_event_email(invite)
    @event = invite.event
    @subject = invite.subject
    @inviter = invite.user
    mail(to: invite.email, subject: @subject)
  end

   def invite_game_event_email(invite)
    @game_event = invite.game_event
    @subject = invite.subject
    @inviter = invite.user
    mail(to: invite.email, subject: @subject)
  end

  def invite_group_email(invite)
    @group = invite.group
    @subject = invite.subject
    @inviter = invite.user
    mail(to: invite.email, subject: @subject)
  end
end
