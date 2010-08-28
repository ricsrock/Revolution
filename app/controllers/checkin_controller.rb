class CheckinController < ApplicationController
  
  before_filter :login_required
  
  require_role [:checkin_user, :supervisor]
  # require_role "supervisor", :only => 'event_changed'
  

  def index
    redirect_to :action => 'home'
  end

  def home
    @phrase = params[:searchtext]
    @phrase ||= current_user.preferences[:query]
    @phrase ||= ""
    current_user.set_preference!(:query,@phrase)
    a1 = "%"
    a2 = "%"
    @searchphrase = a1 + @phrase.to_s + a2
    @found_households = Household.find(:all, :conditions => [ "name LIKE ? OR people.first_name LIKE ? OR people.last_name LIKE ?", @searchphrase, @searchphrase, @searchphrase],
                                       :include => [:people], :order => 'name Asc')
    for number in Phone.find(:all, :conditions => ['number LIKE ? AND phones.phonable_type = "Household"', @searchphrase],
                                   :joins => ['INNER JOIN households ON households.id = phones.phonable_id'], :limit => 2)
 		  @found_households << number.phonable unless @found_households.detect { |household| household.id == number.phonable_id }
 		end
    @number_match = @found_households.length
    instance_id = Setting.one.current_instance
    @available_meetings = Meeting.find_by_selected_instance(instance_id)
    @checkin_types = CheckinType.find(:all)
    @available_events = Event.find(:all, :conditions => ["events.date BETWEEN '#{(Time.now - 14.days).to_date}' AND '#{(Time.now + 14.days).to_date}'"])
    @curr_instance = Instance.find_current
    
  end
  
  def search_changed
    conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
    @found_households = Household.find(:all, :conditions => conditions)
    
    if request.xml_http_request?
          render :partial => "households", :layout => false
    end
    
  end
  
  def live_search
      @phrase = params[:name]
      a1 = "%"
      a2 = "%"
      @searchphrase = a1 + @phrase.to_s + a2
      @found_households = Household.find(:all, :conditions => [ "name LIKE ?", @searchphrase])

      @number_match = @found_households.length

      render :partial => "households"
  end
  
  def plain_search
      @phrase = params[:searchtext]
      a1 = "%"
      a2 = "%"
      @searchphrase = a1 + @phrase.to_s + a2
      @found_households = Household.find(:all, :conditions => [ "name LIKE ?", @searchphrase])

      @number_match = @found_households.length

      render :partial => "households", :layout => false
  end
  
  
  def event_changed
      render :partial => "select_instance", :locals => { :event_id => params[:id]}
  end
  
  def instance_set
      Setting.one.update_attributes(:current_instance => params[:id])
      #redirect_to :action => 'home'
      flash[:notice] = "Click apply to set the current check-in service."
  end

  
  def checkin
    @message = []
    @form_meeting = Meeting.find(:first, :conditions => {:id => params[:attendance][:meeting_id]})
    curr_instance = Setting.one.current_instance
    @instance = Instance.find(curr_instance)
    if @instance.event.date <= (Date.today - 2)
      @message = "You cannot check people into a meeting that happened in the past. Please check the settings and try again."
    else
    person = Person.find(params[:person_id])
    @default_meeting = Meeting.find(:first, :conditions => {:instance_id => curr_instance, :group_id => person.default_group_id})
    if @form_meeting.nil?
        @meeting = @default_meeting
      else
        @meeting = @form_meeting
    end
    if @meeting.nil?
      @message = "There is no meeting for #{person.first_name}'s default group, which is #{person.default_group.name}."
    else
      letters = ("A".."Z").to_a
      numbers = ("0".."9").to_a
      newcode = ""
      3.times {|i| newcode << letters[rand(letters.size-1)]}
      3.times {|i| newcode << numbers[rand(numbers.size-1)]}
      
      #put this in a method with built in uniqueness verification
      #Attendance.get_phrase(meeting_id) then find the instance and make the phrase unique for the service-instance
      # find all phrases for that instance and see if @phrases.include?(new_phrase)
#   @adjectives = Adjective.find(:all).collect {|a| a.name}
#   @animals = Animal.find(:all).collect {|b| b.name}
#   @colors = Color.find(:all).collect {|c| c.name}
#   phrase = ""
#   phrase << @adjectives[rand(@adjectives.length)]
#   phrase << " "
#   phrase << @colors[rand(@colors.length)]
#   phrase << " "
#   phrase << @animals[rand(@animals.length)]
      phrase = Attendance.unique_security_phrase(@meeting.id)
      call_number = Attendance.unique_call_number(@meeting.id)
      @attendance = Attendance.new(:person_id => params[:person_id],
                                     :meeting_id => @meeting.id,
                                     :checkin_type_id => params[:attendance][:checkin_type_id],
                                     :checkin_time => Time.now,
                                     :call_number => call_number,
                                     :security_code => phrase)
    if @attendance.save
      flash[:notice] = "#{person.first_name} was successfully checked into the #{@attendance.meeting.group.name} class."
      #person.enroll_in_group(@meeting.group.id)
      @success = "true"
    else
      flash[:notice] = "There was a problem checking #{person.first_name} into the #{@attendance.meeting.group.name} class. \n
                        Try another class or check the <a href='/meetings/detail/#{@attendance.meeting.id}'>meeting's history</a> to see if #{person.first_name} has already been checked in and out of this meeting."
      @success = "false"
    end
    end
#      redirect_to :action => "home"
    instance_id = Setting.one.current_instance
    @household = person.household
    @available_meetings = Meeting.find_by_selected_instance(instance_id)
    @checkin_types = CheckinType.find(:all)
    @available_events = Event.find(:all)
    @curr_instance = Instance.find_current
    instance_id = Setting.one.current_instance
    @person = person
  end
    render :layout => false
  end
  
  def move_checkin
    #find person
    @person = Person.find(params[:person_id])
    #find current attendance
    @curr_instance = Instance.find_current
    @curr_event = @curr_instance.event
    if @curr_instance && @curr_event
        @curr_attendance = @person.active_attendances_other_instance_this_event(@curr_instance.id,@curr_event.id).first
    end
    if @curr_attendance
        @old_attendance = Attendance.find(@curr_attendance.id)
    end
    if @old_attendance 
        #checkout current attendance
        @old_attendance.update_attribute(:checkout_time, Time.now)
        #create new attendance w/ no checkout time and same security code
        @curr_group_id = @old_attendance.meeting.group.id
        @new_meeting = Meeting.find_by_instance_and_group(@curr_instance.id,@curr_group_id)
        @new_attendance = Attendance.new(:person_id => @person.id,
                                         :meeting_id => @new_meeting.id,
                                         :security_code => @old_attendance.security_code,
                                         :checkin_time => Time.now)
        if @new_attendance.save 
            #done - redirect to home
            flash[:notice] = "#{@person.full_name} was checked out & checked into the #{@new_meeting.group.name} meeting for #{@curr_instance.instance_type.name rescue nil}."
        else
            flash[:notice] = "Sorry. Something went wrong."
        end
    else
        flash[:notice] = "Couldn't find the right meeting to put this person in. Sorry."
    end
    redirect_to :action => 'home'
  end
  
  def checkout
    @active_checkins = Attendance.active_by_person(params[:person_id])
    @active_checkins.each do |setout|
      setout.update_attributes(:checkout_time => Time.now)
    end
    person = Person.find(params[:person_id])
    person.set_recent_attend
    redirect_to(:back)
  end
  
  def checkin_household
    @household = Household.find(params[:id])
    @household.people.each do |person|
      person.checkin_mod
    end
    redirect_to(:back)
  end
  
  def checkout_household
    @household = Household.find(params[:id])
    @household.active_attendances.each do |setout|
      setout.update_attributes(:checkout_time => Time.now)
    end
    redirect_to(:back)
  end
  
  def undo
    @person = Person.find(params[:person_id])
    @attendances = @person.active_attendances_by_instance(params[:instance_id]).each do |a|
      a.destroy
    end
    flash[:notice] = "The checkin record for #{@person.first_name} was deleted."
    redirect_to :action => 'home'
  end
  
  def self
    @search = ""
    @by = "Phone Number"
    @pad = "num_pad"
    render(:layout => 'self_checkin')
  end
  
  def key_pressed
    if params[:key] == "Backspace" or params[:key] == "<"
      @search = params[:search].chop
    elsif params[:key] == "Clear"
      @search = ""
    else
      @search = params[:search] << params[:key]
    end
    @pad = params[:pad]
    render :update do |page|
      page << "Element.appear('spinner')"
      page.replace_html 'search_text', :partial => 'search_text', :locals => {:search => @search}
      page.replace_html 'pad_area', :partial => @pad, :locals => {:search => @search} 
      page.replace_html 'search_button_area', :partial => 'search_button', :locals => {:search => @search}
      page << "Element.fade('spinner')"
    end
  end
  
  def by_selected
    if params[:the_last_name_button]
      chosen = params[:the_last_name_button]
      @pad = 'alpha_keyboard'
    elsif params[:the_phone_number_button]
      chosen = params[:the_phone_number_button]
      @pad = 'num_pad'
    else
      false
    end
    @by = chosen
    @search = ""
    render :update do |page|
      page.replace_html 'radio_buttons', :partial => 'radio_buttons', :locals => {:by => @by}
      page.replace_html 'pad_area', :partial => @pad
      page.replace_html 'search_text', :partial => 'search_text'
      page.replace_html 'search_button_area', :partial => 'search_button', :locals => {:search => @search}
      page.replace_html 'checkin_selected_area', ""
      page.replace_html 'results_area', ""
      page.replace_html 'search_again_area', ""
    end
  end
  
  def search
    search = params[:by].blank? ? "zxzxzxzxzxzxzxzxzxzx" : params[:by]
    @results = Household.find(:all, :conditions => ['households.name LIKE ? OR phones.number LIKE ?', search, '%' + search],
                                    :joins => ["LEFT OUTER JOIN phones on (households.id = phones.phonable_id AND phones.phonable_type = 'Household')"])
    render :update do |page|
      page.replace_html 'pad_area', ""
      page.replace_html 'search_button_area', ""
      page.replace_html 'results_area', :partial => 'search_results', :locals => {:results => @results}
      page.replace_html 'search_again_area', :partial => 'search_again'
      page.replace_html 'checkin_selected_area', :partial => 'checkin_selected_button', :locals => {:search => @search}
    end
  end
  
  def test
    render :layout => false
  end
  
end

