class AlertMailer < ActionMailer::Base
  default from: "alerts@hackgamesocial.herokuapp.com"

  def alert_email(alert)
  	@user = alert.user
  	@body = alert.description
  	@subject = alert.title
    mail(to: @user.email, subject: @subject) if @user.email
  end
end
