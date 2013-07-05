class FixUnattributedContactType < ActiveRecord::Migration
  def change
    contacts = Contact.where('contactable_type = ?', 'Unattributed')
    contacts.each do |c|
      c.update_attribute(:contactable_type, nil)
    end
  end
end
