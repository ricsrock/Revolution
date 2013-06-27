class ContactForm < ActiveRecord::Base
  has_and_belongs_to_many :contact_types, :join_table => "contact_forms_contact_types"
  
  acts_as_stampable
  
  
  def available_contact_types
    ContactType.where('contact_types.id NOT IN
                      (SELECT contact_forms_contact_types.contact_type_id FROM contact_forms_contact_types
                      WHERE (contact_forms_contact_types.contact_form_id = ?))', self.id).order(:name)
  end
  
end
