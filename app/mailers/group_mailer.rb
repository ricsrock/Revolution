class GroupMailer < ActionMailer::Base
  default from: "do-not-reply@local.rivervalleychurch.net"
  
  def message_per_person(recipient_id, current_user_id, subject, message)
    # @group = Group.find(group_id)
    @user = User.find(current_user_id)
    @recipient = Person.find(recipient_id)
    @message = message
    mail(
      to: "#{@recipient.full_name} <#{@recipient.best_email}>",
      subject: subject,
      from: "#{@user.full_name} <#{@user.email}>"
    )
  end
  
end
