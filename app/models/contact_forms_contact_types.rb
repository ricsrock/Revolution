class ContactFormsContactTypes < ActiveRecord::Base
  belongs_to :contact_form, :class_name => "ContactForm", :foreign_key => "contact_form_id"
  belongs_to :contact_type, :class_name => "ContactType", :foreign_key => "contact_type_id"
  
  validates :contact_form_id, :contact_type_id, presence: true
  validates_uniqueness_of :contact_form_id, scope: :contact_type_id #contact_type can be on form only once
end
