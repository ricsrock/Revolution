class VolunteerMailer < ActionMailer::Base
  
  attr_accessor :copy_me
  
  def confirm(involvement)
    subject           "River Valley Church Volunteer Ministry Confirmation"
    recipients        involvement.person.best_email_smart
    from              User.current_user.email
    #sent_on           Time.now
    body(:involvement => involvement)
  end
  
  def group_contact(subject, message, person, current_user_email, group)
    subject         subject
    recipients      person.best_email_smart
    from            current_user_email
    body(:person => person, :message => message, :group => group)
  end
  
  def group_text(subject, message, person, current_user_email, group)
      subject         subject
      recipients      person.first_sms.sms_address
      from            current_user_email
      body(:person => person, :message => message, :group => group)
    end
  
  def team_contact(subject, message, person, current_user_email, team)
    subject         subject
    recipients      person.best_email_smart
    from            current_user_email
    body(:person => person, :message => message, :team => team)
  end
  
  def group_contact_portlet(subject, message, person, current_user_email)
    subject         subject
    recipients      person.best_email_smart
    from            current_user_email
    body(:person => person, :message => message)
  end
  
  def smart_group_contact(subject, message, person, current_user_email)
    #person = Person.find(p)
    subject         subject
    recipients      person.best_email_smart
    from            current_user_email
    body(:p => person, :message => message)
  end
  
  def contact_notify(user, current_user_email, contact)
    subject       "Revolution: Contact Notification"
    recipients    user.email
    from          current_user_email
    body(:contact => contact, :user => user)
  end
  
  def follow_up_notify(responsible_user, created_by_user, contact)
      subject       "Revolution: Follow-Up Notification"
      recipients    created_by_user.email
      from          responsible_user.email
      body(:contact => contact, :user => created_by_user)
    end
  
  def contact_transfer_notify(user, current_user_email, contact)
      subject       "Revolution: Contact Transfer Notification"
      recipients    user.email
      from          current_user_email
      body(:contact => contact, :user => user)
    end
    
  def contact_us_copy(sender_email, message, contact_type_id, first_name, last_name)
      @contact_type = ContactType.find(contact_type_id)
      subject       "River Valley Church: Web Contact"
      recipients    sender_email
      from          "info@rivervalleychurch.net"
      body(:message => message, :contact_type => @contact_type, :first => first_name, :last => last_name)
  end
  

  def sent(sent_at = Time.now)
    @subject    = 'VolunteerMailer#sent'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end
  
  def contact(recipient, subject, message, sent_at = Time.now)
        subject      =       subject
        recipients    =      recipient
        from           =     'no-reply@yourdomain.com'
        sent_on         =    sent_at
  	    @body["title"]   =   'This is title'
    	  @body["email"]    =  'sender@yourdomain.com'
     	  @body["message"]   = message
        @headers          = {}
  end
  
  def test_email(subject, recipients, message)
    subject           subject
    recipients        recipients
    from              "lowell@rivervalleychurch.net"
    body(:message => message)
  end
  
  def express_interest_small_group(person_name,person_email,person_message,group,to_email)
    subject       "Small Group Interest Notification"
    recipients    to_email
    from          'rusty@rivervalleychurch.net'
    cc            'rusty@rivervalleychurch.net'
    sent_on       Time.now
    body(:group => group, :person_name => person_name, :person_message => person_message, :person_email => person_email)
  end
  
  def meeting_created_message(created_by,group_name,meeting_date,sender_email,meeting_notes,number_present)
    subject     "A New Small Group Meeting Has Been Created"
    recipients  'lowell@rivervalleychurch.net'
    from        sender_email
    cc          'daphne@rivervalleychurch.net'
    sent_on     Time.now
    body(:created_by => created_by, :group_name => group_name, :meeting_date => meeting_date, :meeting_notes => meeting_notes, :number_present => number_present)
  end
  
end
