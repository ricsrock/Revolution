class AttendanceTracker < ActiveRecord::Base
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  
  validates :person_id, :group_id, :presence => true
  validates_uniqueness_of :group_id, scope: :person_id
  
  def self.update_for_attendance(person_id, group_id)
    tracker = AttendanceTracker.find_or_create_by_person_id_and_group_id(person_id,group_id)
    person = Person.find(person_id)
    if !person.attendances_for_group_id(tracker.group_id).empty?
      new_values = {:most_recent_attend => person.attendances_for_group_id(tracker.group_id).order('events.date DESC').first.date.to_time.to_s(:db),
                    :first_attend => person.attendances_for_group_id(tracker.group_id).order('events.date ASC').first.date.to_time.to_s(:db),
                    :count => person.attendances_for_group_id(tracker.group_id).size}
      tracker.update_attributes(new_values)
    else
      tracker.destroy
    end
  end
  
end
