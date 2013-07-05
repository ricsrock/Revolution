class FixMissingContactStamps < ActiveRecord::Migration
  def change
    contacts = Contact.where('stamp IS NULL')
    contacts.each do |c|
      c.set_stamp
      c.save!
    end
  end
end
