class SetContactStatus < ActiveRecord::Migration
  def change
    Contact.all.each do |contact|
      if contact.closed_at.present?
        status = 'Closed'
      elsif contact.follow_ups.present?
        status = 'In Progress'
      else
        status = 'Open'
      end
      contact.update_attribute(:status, status)
    end
  end
end
