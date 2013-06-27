class ContactMailer < ActionMailer::Base
  default from: "do-not-reply@local.rivervalleychurch.net"
  
  def notification(contact)
    @contact = contact
    mail(
      to: contact.responsible_user.email,
      subject: "You have a new contact"
    )
  end
  
end
