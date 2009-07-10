class AttendanceTracker < ActiveRecord::Base
  belongs_to :person
  belongs_to :group
  
  validates_uniqueness_of :group_id, :scope => :person_id, :message => "We're already tracking this group for this person." #one tracker for a given group... per person

  def self.do_new_attendance(record)
    tracker = AttendanceTracker.find_or_create_by_person_id_and_group_id(record.person.id,record.meeting.group.id)
    new_values = {:most_recent_attend => record.person.recent_attend_this_group(record.meeting.group.id)[:date].to_time,
                  :first_attend => record.person.first_attend_this_group(record.meeting.group.id)[:date].to_time,
                  :count => record.person.attended_meetings_this_group(record.meeting.group.id).length}
    tracker.update_attributes(new_values)
  end

end
