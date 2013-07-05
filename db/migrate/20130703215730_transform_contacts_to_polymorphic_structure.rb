class TransformContactsToPolymorphicStructure < ActiveRecord::Migration
  def change
    contacts = Contact.all
    contacts.each do |c|
      if c.person_id.present?
        c.update_attributes(contactable_id: c.person_id, contactable_type: 'Person')
      elsif c.household_id.present?
        c.update_attributes(contactable_id: c.household_id, contactable_type: 'Household')
      else
        c.update_attributes(contactable_type: 'Unattributed')
      end
    end
  end
end
