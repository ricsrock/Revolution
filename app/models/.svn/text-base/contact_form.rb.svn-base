class ContactForm < ActiveRecord::Base
  has_and_belongs_to_many :contact_types, :order => :name
  
  def available_contact_types
    @all_contact_types = ContactType.find(:all, :order => :name)
    @joined_contact_types = self.contact_types
    @all_contact_types - @joined_contact_types    
  end
end
