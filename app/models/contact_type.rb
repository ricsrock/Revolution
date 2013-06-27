class ContactType < ActiveRecord::Base
  has_and_belongs_to_many :contact_forms, :join_table => "contact_forms_contact_types"
  belongs_to :default_responsible_user, :class_name => "User", :foreign_key => "default_responsible_user_id"
  belongs_to :default_follow_up_type, :class_name => "FollowUpType", :foreign_key => "default_follow_up_type_id"
  has_many :contacts, dependent: :restrict_with_exception
  
  validates :default_responsible_user_id, :name, :presence => true
  validates :default_follow_up_type_id,
            presence: { message: "You must choose a default follow-up type to use this as a quick contact" },
            if: Proc.new { |a| a.quick_contact? } # checked but no follow-up type
  validate :follow_up_type_without_quick_contact
  
  attr_accessor :comments, :included, :responsible_user_id
  
  acts_as_stampable
  
  def follow_up_type_without_quick_contact # follow-up type but not checked
    if ( ! self.default_follow_up_type_id.blank? ) && ( ! self.quick_contact? )
      errors.add(:quick_contact, "You must set this as a quick contact type if you choose a default follow-up type")
    end
  end
  
  def self.quick
    where(quick_contact: true).order(:name)
  end
  
end
