class Message < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  has_many :recipients, dependent: :destroy
  has_many :people, through: :recipients
  
  validates :from, :body, :presence => true
  #validate :must_have_recipients
  
  #serialize :recipients
  
  accepts_nested_attributes_for :recipients
  
  has_ancestry cache_depth: true
  
  acts_as_stampable
  
  # attr_accessor :recipients_attributes
  # 
  # def recipients_attributes=(person_ids)
  #   person_ids.each do |id|
  #     person = Person.find id
  #     r = self.recipients.new(person_id: person.id, number: person.mobile_number)
  #     r.save
  #   end
  # end
  
  # def must_have_recipients
  #   if recipients.empty? or recipients.all? {|child| child.marked_for_destruction? }
  #     errors.add(:base, 'Must have at least one recipient')
  #   end
  # end
  
  # def add_child_and_notify(message_attributes)
  #   child = self.children.create(message_attributes)
  #   number = message_attributes[:from]
  #   person = Person.where('phones.number = ?', number[-10..-1]).joins(:phones).first
  #   child.recipients << Recipient.create(person_id: person.id, number: '+1' + person.mobile_number.to_s)
  #   
  #   account_sid = CONFIG[:twilio_account_sid]
  #   auth_token = CONFIG[:twilio_auth_token]
  #   client = Twilio::REST::Client.new account_sid, auth_token
  #   home = "+13183034399"
  #   client.account.sms.messages.create(
  #       :from => home,
  #       :to => self.from,
  #       :body => "You have a reply: " + child.body
  #     )
  # end
  
  def sender
    self.user ? "+1" + user.mobile_number.to_s : from
  end
  
  def from_person
    Person.where('phones.number = ?', sender[-10..-1]).joins(:phones).first
  end
    
end
