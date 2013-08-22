class InquiryMailer < ActionMailer::Base
  helper :small_groups
  default from: "from@example.com"
  
  def notification(inquiry, current_user)
    @inquiry = inquiry
    @user = current_user
    mail(
      to: inquiry.person.best_email,
      from: "#{@user.full_name} <#{@user.email}>",
      subject: "Small Group Info: #{inquiry.group.name}"
    )
  end
  
end
