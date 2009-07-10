class MeetingObserver < ActiveRecord::Observer
#def after_create(user)
#  UserNotifier.deliver_signup_notification(user)
#end

  def after_create(meeting)
    begin
    if meeting.group.is_a_small_group?
      options = {}
      options[:created_by] = meeting.created_by
      options[:group_name] = meeting.group.name
      options[:meeting_date] = meeting.real_date? ? meeting.real_date.strftime('%m/%d/%Y') : Time.now.strftime('%m/%d/%Y')
      options[:sender_email] = User.find_by_login(meeting.created_by).email
      options[:meeting_notes] = meeting.comments
      options[:number_present] = meeting.num_marked
      EmailWorker.asynch_do_meeting_notify(options)
    end
   rescue
   end
 # UserNotifier.deliver_forgot_password(user) if user.recently_forgot_password?
 # UserNotifier.deliver_reset_password(user) if user.recently_reset_password?
  end
end