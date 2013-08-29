class InquiryMailer < ActionMailer::Base
  helper :small_groups
  default from: "from@example.com"
  
  def notification(inquiry, current_user)
    @inquiry = inquiry
    @message = Setting.inquiry_email_body
    @user = current_user
    mail(
      to: inquiry.person.best_email,
      from: "#{@user.full_name} <#{@user.email}>",
      subject: "Small Group Info: #{inquiry.group.name}"
    )
  end
  
  def notify_group_leader(group, people_ids, current_user)
    @people = Person.where(id: people_ids)
    @group = group
    @user = current_user
    mail(
      to: @group.primary_leaders.with_email.collect {|p| p.best_email},
      from: "#{@user.full_name} <#{@user.email}>",
      subject: "Interest In Your Group: #{@group.name}"
    )
  end
  
end
