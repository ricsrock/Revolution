class FixContactsWithoutTypeId < ActiveRecord::Migration
  def change
    contacts = Contact.where('contact_type_id IS NULL')
    contacts.each do |c|
      c.update_attribute(:contact_type_id, ContactType.first.id)
    end
  end
end
