class User < ActiveRecord::Base
  
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  
  has_many :contacts, :class_name => "Contact", :foreign_key => "responsible_user_id"
  has_many :favorites, dependent: :destroy
  has_many :favorite_smart_groups, through: :favorites, source: :favoritable, source_type: "SmartGroup", foreign_key: "favoritable_id"

  has_and_belongs_to_many :roles
  has_many :permissions, through: :roles
  
  cattr_accessor :the_user
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, encryptor: :restful_authentication_sha1


  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  serialize :preferences, Hash
  
  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :roles
  
  # ransacker :full_name do |parent|
  #   Arel::Nodes::InfixOperation.new('||',
  #     Arel::Nodes::InfixOperation.new('||', parent.table[:first_name], ' '),
  #     parent.table[:last_name])
  # end
  
  ransacker :full_name, :formatter => proc {|v| v.downcase } do |parent|
      Arel::Nodes::NamedFunction.new('LOWER',
        [Arel::Nodes::NamedFunction.new('concat_ws', [' ', parent.table[:first_name], parent.table[:last_name]])]
      )
  end
  
  ransacker :last_first_name, :formatter => proc {|v| v.downcase } do |parent|
      Arel::Nodes::NamedFunction.new('LOWER',
        [Arel::Nodes::NamedFunction.new('concat_ws', [' ', parent.table[:last_name], parent.table[:first_name]])]
      )
  end
  
  
  
  # ransacker :full_name, :formatter => proc {|names| names.split(' ')}, :splat_param => true do |parent|
  #   Arel::Nodes::InfixOperation.new('OR',
  #     Arel::Nodes::InfixOperation.new('OR', parent.table[:first_name], ' '),
  #     parent.table[:last_name])
  # end
  
  
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def self.active
    where('users.confirmed_at IS NOT NULL')
  end
  
  def admin?
    self.roles.collect(&:name).include?('admin')
  end
  
  # If current_user created the contact...
  def can_access?(contact)
    if self.has_role?('admin') or self.has_role?('confidential') or contact.created_by == self.login or contact.responsible_user_id == self.id
      true
    elsif ! contact.confidential?
      true
    else
      false
    end
  end
  
  def has_role?(role)
    self.roles.collect(&:name).include?(role)
  end
  
  def favorite(object)
    self.send(favorite_collection(object)) << object
    true
  rescue ActiveRecord::RecordInvalid
    return false
  end
  
  def unfavorite(object)
    self.send(favorite_collection(object)).delete(object)
    true
  end
  
  def favorite_collection(object)
    ('favorite_' + object.class.name.underscore.pluralize).to_sym
  end
  
  def favorite_checkin_background
    if ( ! self.preferences[:favorite_checkin_background_id].blank? ) && CheckinBackground.find_by_id(self.preferences[:favorite_checkin_background_id])
      CheckinBackground.find(self.preferences[:favorite_checkin_background_id])
    else
      false
    end
  end
  
  def active_for_authentication? 
    super && confirmed? 
  end
  
  def full_name
    first_name + ' ' + last_name
  end 
  
  def person_name
    person.try(:id_and_full_name)
  end
  
  def person_name=(stuff)
    input = stuff.split(' ')
    self.person = Person.where(:id => input[0]).first
  end
  
  def set_preference!(key, value) #set this preference whether the key already exists or not.
    data = self.preferences || Hash.new
    data.merge!(key => value)
    self.preferences = data
    self.save
  end
  
  def set_preference(key, value) #set this preference ONLY if the key does not already exist.
    data = self.preferences || Hash.new
    return true if data.has_key?(key)
    data.merge!(key => value)
    self.preferences = data
    self.save
  end
  
  # TODO: this should find the first mobile number.
  def mobile_number
    person.phones.first.number
  end
  
  def confirmed?
    confirmed_at.blank? ? false : true
  end
  
  def confirm!
    update_attribute(:confirmed_at, Time.now)
  end
  
  def unconfirm!
    update_attribute(:confirmed_at, nil)
  end
  
  
  
end
