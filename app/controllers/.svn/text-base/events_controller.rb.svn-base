class EventsController < ApplicationController
  
  before_filter :login_required
  
  require_role "supervisor"
  require_role "admin", :only => [:delete_event, :destroy]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @event_pages, @events = paginate :events, :per_page => 10
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    params[:event][:created_by] = current_user.login
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to :action => 'manage'
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    params[:event][:updated_by] = current_user.login
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Event was successfully updated.'
      redirect_to :action => 'show', :id => @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if ! @event.instances.empty?
        flash[:notice] = "You can't delete an event that has instances."
    else
        @event.destroy
        flash[:notice] = "Event was deleted."
    end
    redirect_to :action => 'list'
  end
  
  def delete_event
    @event = Event.find(params[:id])
    if ! @event.instances.empty?
        flash[:notice] = "You can't delete an event that has instances."
    else
        @event.destroy
        flash[:notice] = "Event was deleted."
    end    
    @events = Event.find(:all, :order => ['date DESC'])
    event_id = "%"
    @instances = Instance.find_by_event_id(event_id)
    instance_id = "%"
    @found_meetings = Meeting.find_by_instance_id(instance_id)
  end
  
  def add_instance
    unless params[:instance][:instance_type_id].blank?
        @instance = Instance.new(:event_id => params['id'], :instance_type_id => params[:instance][:instance_type_id])
        if @instance.save
          flash[:notice] = 'Instance was successfully added to this event.'
          Event.find(params[:id]).update_attributes(:updated_by => current_user.login, :updated_at => Time.now)
        end
    else
        flash[:notice] = 'You must select an instance type.'
    end
    redirect_to(:back)
  end
  
  def manage
    @events = Event.find_by_ez_where("Last 30 Days")
    @instances = Instance.find_by_event_ids(@events)
    @found_meetings = Meeting.find_by_instance_ids(@instances)
  end
  
  def filter_events
    range_result = params[:range]
    @events = Event.find_by_ez_where(range_result)
    @instances = Instance.find_by_event_ids(@events)
    @found_meetings = Meeting.find_by_instance_ids(@instances)
  end
  
  def event_changed
    event_id = params[:id]
    @instances = Instance.find_by_event_id(event_id)
    @event = Event.find(params[:id])
    @found_meetings = @event.meetings
  end
  
  def instance_changed
    instance_id = params[:id]
    @found_meetings = Meeting.find_by_instance_id(instance_id)
  end
  
  def stats
    @event = Event.find(params[:id])   
  end
  
  def mark
    #@found_people = Person.find(:all, :include => [:household], :order => ['households.name, people.first_name ASC'])
    #@show_people = @found_people.select {|p| p.enrolled_in_group?("Adult Worship")}
    @show_people = Person.find_all_enrolled_in_group('Adult Worship')
    @event = Event.find(params[:id])
    @breakfast_meeting = Meeting.find_by_event_instance_name_group_name(params[:id], '1st Service (9:00AM)', 'Breakfast')
    @first_service = Meeting.find_by_event_instance_name_group_name(params[:id], '1st Service (9:00AM)', 'Adult Worship')
    @second_service = Meeting.find_by_event_instance_name_group_name(params[:id], '2nd Service (10:45AM)', 'Adult Worship')
    @breakfast_people = @breakfast_meeting.people_in_attendance.collect {|person| person.id} if @breakfast_meeting
    @first_people = @first_service.people_in_attendance.collect {|person| person.id} if @first_service
    @second_people = @second_service.people_in_attendance.collect {|person| person.id} if @second_service
    @show_people.each do |p|
        p[:breakfast] = @breakfast_people.include?(p.id) ? true : false if @breakfast_meeting
        p[:first] = @first_people.include?(p.id) ? true : false if @first_service
        p[:second] = @second_people.include?(p.id) ? true : false if @second_service
    end
  end
  
  def filter_people
      if params[:person_name].blank?
        if params[:people][:filter] == "All"
          @found_people = Person.find(:all, :include => [:household], :order => ['households.name, people.first_name ASC'])
          @set_name = 'all'
        elsif params[:people][:filter] == "Recent Attenders"
          @found_people = Person.find_recent_attenders
          @set_name = 'recent_attenders'
        elsif params[:people][:filter] == "Newcomers"
          @found_people = Person.find_newcomers
          @set_name = 'newcomers'
        elsif params[:people][:filter] == "Active Attenders"
          @found_people = Person.find_active_attenders
          @set_name = 'active_attenders'
        end
        @show_people = @found_people
    else
        names = params[:person_name].split(',')
          if names.length == 1
            conditions = ['last_name LIKE ?', params[:person_name].strip + '%']
          elsif names.length >= 2
            conditions = ['first_name LIKE ? AND last_name LIKE ?', names[1].strip + '%', names[0].strip + '%']
          end
          @show_people = Person.find(:all, :conditions => conditions, :order => ['last_name, first_name ASC'])
          @set_name = 'search'
    end
    @event = Event.find(params[:id])
    @breakfast_meeting = Meeting.find_by_event_instance_name_group_name(params[:id], '1st Service (9:00AM)', 'Breakfast')
    @first_service = Meeting.find_by_event_instance_name_group_name(params[:id], '1st Service (9:00AM)', 'Adult Worship')
    @second_service = Meeting.find_by_event_instance_name_group_name(params[:id], '2nd Service (10:45AM)', 'Adult Worship')
    @breakfast_people = @breakfast_meeting.people_in_attendance.collect {|person| person.id} if @breakfast_meeting
    @first_people = @first_service.people_in_attendance.collect {|person| person.id} if @first_service
    @second_people = @second_service.people_in_attendance.collect {|person| person.id} if @second_service
    @show_people.each do |p|
        p[:breakfast] = @breakfast_people.include?(p.id) ? true : false if @breakfast_meeting
        p[:first] = @first_people.include?(p.id) ? true : false if @first_service
        p[:second] = @second_people.include?(p.id) ? true : false if @second_service
    end
  end
    
  def mark_attendance
      @group = Group.find_by_name("Adult Worship")
      @first_adult_meeting = Meeting.find_by_event_instance_name_group_name(params[:event_id], '1st Service (9:00AM)', 'Adult Worship')
      if @first_adult_meeting
        unless params[:first_service_people].nil?
          params[:first_service_people].each do |person_id|
            person = Person.find(person_id)
            Attendance.create(:person_id => person_id, :meeting_id => @first_adult_meeting.id,
                              :checkin_time => Time.now, :checkout_time => Time.now,
                              :checkin_type_id => 1)
            person.enroll_in_group(@group.id)
          end
        end
      end
      @second_adult_meeting = Meeting.find_by_event_instance_name_group_name(params[:event_id], '2nd Service (10:45AM)', 'Adult Worship')
      if @second_adult_meeting
        unless params[:second_service_people].nil?
          params[:second_service_people].each do |person_id|
            person = Person.find(person_id)
            Attendance.create(:person_id => person_id, :meeting_id => @second_adult_meeting.id, :checkin_time => Time.now, :checkout_time => Time.now,
                              :checkin_type_id => 1)
            person.enroll_in_group(@group.id)
          end
        end
      end
      @breakfast_meeting = Meeting.find_by_event_instance_name_group_name(params[:event_id], '1st Service (9:00AM)', 'Breakfast')
      if @breakfast_meeting
        unless params[:breakfast_people].nil?
          params[:breakfast_people].each do |person_id|
            Attendance.create(:person_id => person_id, :meeting_id => @breakfast_meeting.id, :checkin_time => Time.now, :checkout_time => Time.now,
                              :checkin_type_id => 1)
          end
        end
      end
    redirect_to :action => 'mark', :id => params[:event_id]
  end
  
  def edit_counts
    @event = Event.find(params[:id])
  end
  
  def update_counts
    @event = Event.find(params[:event_id])
    params[:meetings].each do |id, meeting|
      @meeting = Meeting.find(id)
      @meeting.update_attributes(meeting)
      @meeting.set_total
    end
    flash[:notice] = 'Head counts have been successfully updated.'
    redirect_to :action => 'show_counts', :id => @event
  end
  
  def show_counts
    @event = Event.find(params[:id])
  end
  
  def mass_create
    
  end
  
  def create_in_mass
    beginning_date = params[:event][:start_date].to_date
    weekday = Date::DAYNAMES.index(params[:event][:weekday])
    number_of = params[:event][:number].to_i
    event_type_id = params[:event][:type_id].to_i
    Event.create_in_mass(number_of,event_type_id,weekday,beginning_date)
    @ending_date = (params[:event][:start_date].to_time + params[:event][:number].to_i.weeks).to_date
  end
  
  def counts_form_changed
    @totals = {}
    params[:meetings].each do |id, meeting|
      @m = Meeting.find(id)
      @m.update_attributes(meeting)
      @m.set_total
#     total = (meeting[1][:leaders_count].to_i + meeting[1][:participants_count].to_i)
#     @totals.merge!(meeting[0]=>total)
    end

  end
  
  def leaders_changed
    @meeting = Meeting.find(params[:id])
    @meeting.update_attribute(:leaders_count,params[:leaders_count])
    @meeting.set_total
    @instance = Instance.find(params[:instance])
  end
  
  def participants_changed
    @meeting = Meeting.find(params[:id])
    @meeting.update_attribute(:participants_count,params[:participants_count])
    @meeting.set_total
    @instance = Instance.find(params[:instance])
  end
  
end
