class ReportsController < ApplicationController
  
  before_filter :login_required

  require 'csv'
  require 'faster_csv'
 
  def rosters
    @curr_attendances = Attendance.all_active
  end
  
  def csv
      @group = Group.find(params[:id])

      csv_string = FasterCSV.generate do |csv|
        csv << ["FirstName", "LastName", "Address1", "Address2", "City", "State", "Zip", "Phone", "Email"]

        @group.current_enrollments.each do |enrollment|
          csv << [enrollment.person['first_name'],
                  enrollment.person['last_name'],
                  enrollment.person.household['address1'],
                  enrollment.person.household['address2'],
                  enrollment.person.household['city'],
                  enrollment.person.household['state'],
                  enrollment.person.household['zip'],
                  enrollment.person.household.best_phone['number'],
                  enrollment.person.household.best_email['email']]
        end
      end

      filename = @group.name.downcase.gsub(/[^0-9a-z]/, "_") + ".csv"
      send_data(csv_string,
        :type => 'text/csv; charset=utf-8; header=present',
        :filename => filename)
    end
    
    def export_group
        @group = Group.find(params[:id])

        csv_string = FasterCSV.generate do |csv|
          csv << ["FirstName", "LastName", "Address1", "Address2", "City", "State", "Zip", "Phone", "Email"]

          @group.current_enrollments.each do |enrollment|
            if enrollment.person
                if enrollment.person.household
            csv << [enrollment.person['first_name'],
                    enrollment.person['last_name'],
                    enrollment.person.household['address1'],
                    enrollment.person.household['address2'],
                    enrollment.person.household['city'],
                    enrollment.person.household['state'],
                    enrollment.person.household['zip'],
                    enrollment.person.household.best_phone_s_formatted,
                    enrollment.person.best_email_smart]
                end
            end
          end
        end

        filename = @group.name.downcase.gsub(/[^0-9a-z]/, "_") + ".csv"
        send_data(csv_string,
          :type => 'text/csv; charset=utf-8; header=present',
          :filename => filename)
      end
      
      def export_stats
        @events = Event.find(:all, :include => :event_type, :conditions => ['event_types.name LIKE ?', 'Celebration Service'])
        csv_string = FasterCSV.generate do |csv|
          csv << ["Date", "Event Type", "Weekly Head Count"]
          @events.each do |e|
            csv << [e.date,e.event_type.name,e.head_count['head_count'].to_i]
          end
        end
        
        filename = "events_stats.csv"
        send_data(csv_string,
                  :type => 'text/csv; charset=utf-8; header=present',
                  :filename => filename)
        
      end
      
      def export_smart_group
          @smart_group = SmartGroup.find(params[:id])

          csv_string = FasterCSV.generate do |csv|
            csv << ["FirstName", "LastName", "Address1", "Address2", "City", "State", "Zip", "Phone", "Email"]

            @smart_group.found_people.each do |person|
            if person.household
              #person = Person.find(p.id)
              csv << [person['first_name'],
                      person['last_name'],
                      person.household['address1'],
                      person.household['address2'],
                      person.household['city'],
                      person.household['state'],
                      person.household['zip'],
                      person.household.best_phone_s_formatted,
                      person.best_email_smart]
            end
            end
          end

          filename = @smart_group.name.downcase.gsub(/[^0-9a-z]/, "_") + ".csv"
          send_data(csv_string,
            :type => 'text/csv; charset=utf-8; header=present',
            :filename => filename)
        end
        
        def export_smart_group_households
              @smart_group = SmartGroup.find(params[:id])

              csv_string = FasterCSV.generate do |csv|
                csv << ["LastName", "Address1", "Address2", "City", "State", "Zip", "Phone", "Email"]

                @smart_group.found_households.sort_by {|p| p.household ? p.household.name : 'false'}.each do |h|
                  #person = Person.find(p.id)
                  if h.household
                      csv << [h.household['name'],
                              h.household['address1'],
                              h.household['address2'],
                              h.household['city'],
                              h.household['state'],
                              h.household['zip'],
                              h.household.best_phone_s_formatted,
                              h.household.best_email_smart]
                 end
                end
              end

              filename = @smart_group.name.downcase.gsub(/[^0-9a-z]/, "_") + "households" + ".csv"
              send_data(csv_string,
                :type => 'text/csv; charset=utf-8; header=present',
                :filename => filename)
            end



        def export_batch_of_contacts
         csv_string = FasterCSV.generate do |csv|
            csv << ["FirstName", "LastName", "Address1", "Address2", "City", "State", "Zip", "Phone", "Email"]
          current_user.preferences[:selected_ids].each do |id|
            @contact = Contact.find(id)
            if  @contact.person && @contact.person.household
              csv << [@contact.person['first_name'],
                     @contact.person['last_name'],
                     @contact.person.household['address1'],
                     @contact.person.household['address2'],
                     @contact.person.household['city'],
                     @contact.person.household['state'],
                     @contact.person.household['zip'],
                     @contact.person.household.best_phone_s_formatted,
                     @contact.person.best_email_smart]
            elsif  @contact.household
              csv << ["The #{@contact.household['name']} Household",
                      @contact.household['name'],
                      @contact.household['address1'],
                      @contact.household['address2'],
                      @contact.household['city'],
                      @contact.household['state'],
                      @contact.household['zip'],
                      @contact.household.best_phone_s_formatted,
                      @contact.household.best_email['email']]
            else
              flash[:notice] = "You tried to export a contact that wasn't attributed to anyone. Don't play me. Try again."
            end
          end
        end

        filename = "contacts" + ".csv"
        send_data(csv_string,
          :type => 'text/csv; charset=utf-8; header=present',
          :filename => filename)
        end
  
  def csv_import 
    @parsed_file = CSV::Reader.parse(params[:dump][:file])
    n = 0
    @parsed_file.each  do |row|
    c = Person.new
    c.job_title = row[1]
    c.first_name = row[2]
    c.last_name = row[3]
    if c.save
       n = n + 1
       GC.start if n%50 == 0
    end
    flash.now[:message]= "CSV Import Successful, #{n} new records added to data base."
  end
  end
  
  def weekly_contacts
    @contacts = Contact.weekly_report
  end
  
  def weekly_prayer_praise
    @stamps = Contact.weekly_prayer_praise
  end
  
  def weekly_status_advance_decline
    #@tag_ids = [] This does household attenance statuses... attached to person.set_attendance_statuses
    Person.set_status_advance_decline #unless (Setting.one.advance_decline_run_date.nil? or Setting.one.advance_decline_run_date > (Time.now - 6.days))
    Person.set_attendance_statuses
    @tag_group = TagGroup.find_by_name("Status Advance/Decline")
    @tag_ids = @tag_group.tags.collect {|t| t.id}
    @group_names = ["Adult Worship"]
    now = (Time.now + 1.day).to_s(:db)
    begin_week = (Time.now.beginning_of_week - 1.day).to_s(:db)
    @taggings = Tagging.find(:all, :select => ['taggings.id, taggings.tag_id, taggings.person_id, taggings.start_date'],
                              :joins => ['LEFT OUTER JOIN people ON (people.id = taggings.person_id)
                                          LEFT OUTER JOIN enrollments ON (people.id = enrollments.person_id)
                                          LEFT OUTER JOIN groups ON (groups.id = enrollments.group_id)'],
                              :conditions => ["(taggings.start_date BETWEEN '#{begin_week}' and '#{now}')
                                                AND (taggings.tag_id IN (?))
                                                AND (groups.name IN (?))",@tag_ids, @group_names ])
  end
  
  def wheres_waldo
    status = "Active", "Guest"
    group_name = "Adult Worship"  
    @found_people = Person.find_by_status_and_group_enrollment(status, group_name)
  end
  
  def do_auto_contacts
    Person.do_auto_contacts
    flash[:notice] = 'Auto-Contact routine complete.'
    redirect_to :controller => 'dashboard'
  end
  
  def jobs_list
  end
  
  def contact_status
    @staff_members = User.find(:all, :conditions => {:is_staff => true})
  end
  
  def guest_flow
    @group_name = "All Groups"
    @trackers = AttendanceTracker.find(:all)
  end
  
  def filter_guest_flow_results
    unless params[:filter][:group_id] == ""
      group = params[:filter][:group_id]
      combined_cond = Caboose::EZ::Condition.new :attendance_trackers do
        group_id == group
      end
      @group_name = Group.find(params[:filter][:group_id]).name
    else
      combined_cond = Caboose::EZ::Condition.new do
      end
      @group_name = "All Groups"
    end
    combined_cond << Tool.range_condition(params[:filter][:range],"attendance_trackers","first_attend")
    #conditions = ['group_id = ?', @group_id]
    @trackers = AttendanceTracker.find(:all, :conditions => combined_cond.to_sql, :include => [:person])
  end
  
end
