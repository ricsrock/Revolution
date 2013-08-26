class PersonWorker
  include Sidekiq::Worker
  # @queue = :geocoder_queue
  def perform(person_id)
    @person = Person.find(person_id, meeting_id)
    @person.set_first_attend
    @person.set_recent_attend
    @person.set_attend_count
    @person.set_attendance_status
    @person.set_second_attend
    if meeting_id 
      @meeting = Meeting.find(meeting_id)
      @person.set_max_worship_date if @meeting.group.name == 'Adult Worship'
      @person.set_worship_attends if @meeting.group.name == 'Adult Worship'
      @person.enroll_in_group(@meeting.group.id)
    end
    
  end
end