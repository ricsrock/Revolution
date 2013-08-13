class FixDupContactTypes < ActiveRecord::Migration
  def change
    contact_types = ['1st Visit Letter', '2nd Visit Letter', '3rd Visit Letter', 'Active At Risk', 'Guest Reception Invite',
                     'Missed You Letter', 'Newcomer Call']
    contact_types.each do |c|
      group = ContactType.where(name: c)
      while group.size > 1 do
        f = group.first
        l = group.last
        contacts = Contact.where(contact_type_id: l.id)
        contacts.each {|c| c.update_attribute(contact_type_id: f.id)}
        l.destroy
        group = ContactType.where(name: c)
      end
    end
  end
end
