class GroupsController < ApplicationController
  
  before_filter :login_required
  require_role ["checkin_user","supervisor"]
  
  #caches_page :tree_view
  
  
  auto_complete_for :group_choice, :name
  auto_complete_for :curriculum_choice, :name
  auto_complete_for :curriculum_cost, :name
  auto_complete_for :special_requirement, :name
  auto_complete_for :attendance_requirement, :name
  auto_complete_for :is_childcare_provided, :name
  auto_complete_for :meeting_cadence, :name
  auto_complete_for :leader_name_for_printing, :name
  auto_complete_for :meeting_place, :name
  
  def index
    list
    render :action => 'list'
    store_location
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @groups = Group.paginate :page => params[:page], :per_page => 20, :order => :name
    render :action => 'list', :layout => 'inner'
    store_location
  end

  def show
    @group = Group.find(params[:id])
    @found_people = Person.find(:all, :order => ['last_name, first_name ASC'], :limit => 5)
    current_user.set_preference(:group_partial, "enrollments_tab")
    current_user.set_preference(:group_tab, "enrollments_tab")
    current_user.set_preference!(:sticky_group_id, @group.id)
    @enrollments = @group.current_enrollments
    @enrollments_choice = "Current"
    store_location
  end

  def new
    @group = Group.new
  end

  def create
    params[:group][:created_by] = current_user.login
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = 'Group was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
    current_user.set_preference!(:sticky_group_id, @group.id)
  end

  def update
    @group = Group.find(params[:id])
    @archived_already = @group.archived?
    if params[:group_archived] == "true"
        params[:group][:archived_on] = Time.now unless @archived_already
        @group.current_enrollments.each {|e| e.update_attribute(:end_time, Time.now - 5.seconds)} unless @archived_already
        @ended_all = "All enrollments were ended and "
    else
        params[:group][:archived_on] = nil
    end
    if @group.update_attributes(params[:group])
      flash[:notice] = '' << @ended_all.to_s << 'Group was successfully updated.'
      redirect_back_or_default(:action => 'show', :id => @group)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def tree
    flash[:notice] = '' # I can't remember why I blanked out notices for tree view, but it seems dumb.
    @message = ''
    if current_user.preferences[:sticky_group_id] && Group.find_by_id(current_user.preferences[:sticky_group_id])
      @sticky_group = Group.find(current_user.preferences[:sticky_group_id])
    end
    #store_location
    g = Group.first
    u = User.find(current_user.id)
  end
  

  
  def make_child_of
    @descendant = Group.find(params[:id])
    @descendant.update_attributes(:parent_id => params[:new][:parent_group])
    @parent = Group.find(params[:new][:parent_group])
    @descendant.move_to_child_of Group.find(params[:new][:parent_group])
    @parent = params[:new][:parent_group]
  end
  
  def make_root_child_of
    @descendant = Group.find(params[:id])
    @descendant.update_attributes(:parent_id => params[:new][:parent])
    @parent = Group.find(params[:new][:parent])
    @descendant.move_to_child_of Group.find(params[:new][:parent])
    @parent = params[:new][:parent]
    redirect_to :action => 'tree_view'
  end
  
  def new_child
    @parent = Group.find(params[:parent_id])
    @descendant = Group.new(:parent_id => params[:parent_id], :name => params[:child_group][:new_name],
                                                              :tree_id => @parent.root.tree_id,
                                                              :created_by => current_user.login)
    @descendant.save
    @descendant.move_to_child_of @parent
    @root_id = params[:root_id]
  end
  
  def new_root
    @group = Group.new(:name => params[:group][:name], :created_by => current_user.login,
                      :tree_id => Group.new_tree_id)
    if @group.save
      @root = Group.find(@group.id)
    end
  end
  
  def destroy_from_tree
    @message = []
    group = Group.find(params[:id])
    @parent = group.parent.id
    if group.has_children?
      @message = "This group cannot be deleted because it has child groups." << '<br>' << "First delete any child groups, then delete this group."
    elsif group.has_enrollments?
      @message = "This group couldn't be deleted because it has people enrolled. First remove everyone from the group, then delete the group."
    else  
      group.destroy
      @message = "Group was successfully deleted."
    end
    flash[:notice] = @message
  end
  
  def search
    names = params[:person_name].split(',')
    if names.length == 1
      conditions = ['last_name LIKE ?', params[:person_name].strip + '%']
    elsif names.length >= 2
      conditions = ['first_name LIKE ? AND last_name LIKE ?', names[1].strip + '%', names[0].strip + '%']
    end
    @found_people = Person.find(:all, :conditions => conditions, :order => ['last_name, first_name ASC'], :limit => 10)
    @group = Group.find(params[:group_id])
  end
  
  def enroll_person
    @message = []
    flash[:notice] = []
    @group = Group.find(params[:group_id])
    unless @group.has_children?
      @enrollment = Enrollment.new(:person_id => params[:person_id],
                                   :group_id => params[:group_id],
                                   :start_time => Time.now)
      if @enrollment.save
        @message = "#{Person.find(params[:person_id]).full_name} was succesfully added to this group."
      else
        @message = "#{Person.find(params[:person_id]).full_name} couldn't be added to this group."
      end
    else
      @message = "You can only enroll people into groups that are on the end of their branch."
    end
    flash[:notice] = @message
    @enrollments = @group.current_enrollments
    @enrollments_choice = "Current"
  end
  
  def move_enrollments
    @current_group = Group.find(params[:id])
    @new_group = Group.find(params[:new][:group_idee])
    if @new_group.has_children?
      @message = "The people couldn't be moved because the target group is not on the end of the branch. Select another target group and try again."
    else
      @current_group.enrollments.each do |e|
        e.update_attributes(:group_id => @new_group.id)
      end
      @message = "All enrollments were successfully moved to the new group."
    end
  end
  
  def delete_enrollment
    enrollment = Enrollment.find(params[:id])
    @person = enrollment.person
    @group = Group.find(params[:group_id])
    enrollment.destroy
    flash[:notice] = "The enrollment record for #{@person.full_name} was deleted forever."
    @enrollments = @group.current_enrollments
    @enrollments_choice = "Current"
  end
  
  def remove_person
    enrollment = Enrollment.find(params[:id])
    @person = enrollment.person
    enrollment.update_attribute(:end_time, Time.now - 5.seconds)
    @group = Group.find(params[:group_id])
    flash[:notice] = "#{@person.full_name} was removed from this group."
    @enrollments = @group.current_enrollments
    @enrollments_choice = "Current"
  end
  
  def new_group_contact
    @group = Group.find(params[:id])
  end
  
  def new_group_text
    @group = Group.find(params[:id])
  end
  
  
  def send_group_contact
    @sent = []
    @not_sent = []
    @message = []
    @people = []
    options = {}
    options[:subject] = params[:email][:subject]
    options[:message] = params[:email][:message]
    options[:current_user_email] = current_user.email
    options[:group_id] = Group.find(params[:group_id]).id
    params[:included_people].each do |p|
      options[:p] = p
      EmailWorker.asynch_do_group_email(options)
    end
    redirect_back_or_default(:action => 'show', :id => params[:group_id])
  end
  
  def send_group_text
      @people = []
      options = {}
      options[:subject] = params[:email][:subject]
      options[:message] = params[:email][:message]
      options[:current_user_email] = current_user.email
      options[:group_id] = Group.find(params[:group_id]).id
      params[:included_people].each do |p|
        options[:p] = p
        EmailWorker.asynch_do_group_text(options)
      end
      redirect_back_or_default(:action => 'show', :id => params[:group_id])
  end
  
  
  
  def update_special_requirement
    @special_requirement = SpecialRequirement.find_or_create_by_name(params[:special_requirement][:name])
    @group = Group.find(params[:id])
    @group.update_attributes(:special_requirement_id => @special_requirement.id)
  end
  
  def change_partial
    @group = Group.find(params[:group_id])
    @new_partial = params[:new_partial]
    current_user.set_preference!(:group_partial, @new_partial)
    #session[:group_partial] = @new_partial
    current_user.set_preference!(:group_tab, @new_partial)
    #session[:group_tab] = params[:new_partial]
    @variable = params[:new_partial]
  end
  
  def edit_small_group_fields
    @group = Group.find(params[:id])
  end
  
  def update_small_group_fields
    @group = Group.find(params[:id])
    @special_requirement = SpecialRequirement.find_or_create_by_name(params[:special_requirement][:name])
    @curriculum_cost = CurriculumCost.find_or_create_by_name(params[:curriculum_cost][:name])
    @curriculum_choice = CurriculumChoice.find_or_create_by_name(params[:curriculum_choice][:name])
    @attendance_requirement = AttendanceRequirement.find_or_create_by_name(params[:attendance_requirement][:name])
    @is_childcare_provided = IsChildcareProvided.find_or_create_by_name(params[:is_childcare_provided][:name])
    @meeting_cadence = MeetingCadence.find_or_create_by_name(params[:meeting_cadence][:name])
    @meeting_place = MeetingPlace.find_or_create_by_name(params[:meeting_place][:name])
    @leader_name_for_printing = LeaderNameForPrinting.find_or_create_by_name(params[:leader_name_for_printing][:name])
    time_from = ""
    time_until = ""
    time_from = params[:from].collect {|k,v| v}.join(":") if params[:from]
    time_until = params[:until].collect {|k,v| v}.join(":") if params[:until]
    
    @group.update_attributes(:blurb => params[:group][:blurb],
                             :curriculum_choice_id => @curriculum_choice.id,
                             :curriculum_cost_id => @curriculum_cost.id,
                             :special_requirement_id => @special_requirement.id,
                             :attendance_requirement_id => @attendance_requirement.id,
                             :is_childcare_provided_id => @is_childcare_provided.id,
                             :meeting_cadence_id => @meeting_cadence.id,
                             :leader_name_for_printing_id => @leader_name_for_printing.id,
                             :meeting_place_id => @meeting_place.id,
                             :small_group_leader_id => params[:group][:small_group_leader_id],
                             :closed => params[:group][:closed],
                             :time_from => time_from.blank? ? nil : time_from,
                             :time_until => time_until.blank? ? nil : time_until,
                             :meets_on => params[:group][:meets_on],
                             :updated_by => current_user.login,
                             :updated_at => Time.now)
  end
  
  def print_phone_list
    @group = Group.find(params[:id])
  end
  
  
  def new_meeting
    @group = Group.find(params[:id])
  end
  
  def add_meeting
    #params needs: a group_id, a real_date, an event_type_d, and an instance_type_id
    @group = Group.find(params[:group_id])
    recent_sunday = (params[:meeting][:real_date].to_date) - (params[:meeting][:real_date].to_date.wday)
    @event = Event.find_or_create_by_event_type_id_and_date(params[:event_type][:id], recent_sunday)
    @instance = Instance.find_or_create_by_instance_type_id_and_event_id(params[:instance_type][:id], @event.id)
    @meeting = Meeting.new(:instance_id => @instance.id,
                           :group_id => params[:group_id],
                           :room_id => @group.default_room_id,
                           :real_date => params[:meeting][:real_date],
                           :comments => params[:meeting][:comments],
                           :created_by => current_user.login,
                           :num_marked => params[:present_people].size)
    if @meeting.save
        params[:present_people].each do |p|
          Attendance.create(:meeting_id => @meeting.id,
                            :person_id => p,
                            :checkin_time => Time.now,
                            :checkout_time => Time.now)
        end     
        flash[:notice] = 'Meeting was successfully created'
        redirect_to :action => 'show', :id => @group.id
    else
        flash[:notice] = "There was a problem creating the meeting."
        render :action => 'new_meeting', :id => @group
    end
  end
  
  def delete_meeting
    @meeting = Meeting.find(params[:id]).destroy
    @group = Group.find(params[:group_id])
    @meetings = @group.meetings_for_range(current_user.preferences[:range] || "Year To Date")
  end
  
  def event_type_changed
    @event_type = EventType.find(params[:id])
    render :partial => 'select_instance_type', :locals => { :event_type => @event_type }
  end
  
  def show_household_chooser
    @group = Group.find(params[:group_id])
  end
  
  def choose_meeting_household
    @group = Group.find(params[:group_id])
    @found_households = Household.find(:all, :order => ['name ASC'], :limit => 5)
  end
  
  def household_search
    names = params[:household_name]
    conditions = ['name LIKE ?', params[:household_name].strip + '%']
    @found_households = Household.find(:all, :conditions => conditions, :order => ['name ASC'], :limit => 10)
    @group = Group.find(params[:group_id])
  end
  
  def choose_household
    @group = Group.find(params[:group_id])
    @household = Household.find(params[:household_id])
    @group.update_attributes(:meets_at_household_id => @household.id)
  end
  
  def edit_web_categories
    @group = Group.find(params[:group_id])
    @group.web_categories.delete_all
    @group.web_category_ids = params[:group][:web_category_ids]
  end
  
  def set_new_scope
    Group.set_scope(current_user,params[:group][:scope])
    redirect_to :action => 'tree'
  end
  
  def edit_enrollment
    @enrollment = Enrollment.find(params[:id])
  end
  
  def update_enrollment
    @enrollment = Enrollment.find(params[:id])
    
    if @enrollment.update_attributes(:start_time => params[:enrollment][:start_time],
                                  :end_time => params[:enrollment][:end_time])
        flash[:notice] = "The enrollment record was successfully updated"
        redirect_to :action => 'show', :id => @enrollment.group
    else
        render :action => 'edit_enrollment'
    end
  end
  
  def enrollments_changed
    @group = Group.find(params[:group_id])
    case params[:enrollments]
    when "All"
        @enrollments = @group.enrollments
    when "Current"
        @enrollments = @group.current_enrollments
    when "Past"
        @enrollments = @group.past_enrollments
    else
        @enrollments = @group.current_enrollments
    end
    @enrollments_choice = params[:enrollments]
  end
  
  def filter_meetings
    @group = Group.find(params[:group_id])
    session[:range] = params[:filter_range]
    range_cond = Tool.range_condition(params[:filter_range],"events","date")
    @meetings = @group.meetings.find(:all, :conditions => range_cond ? range_cond.to_sql : "1=1",
                                           :include => [:instance => [:event]])
  end
  
  def jump_to_group
    @group = Group.find(params[:id])
    respond_to do |format|
      format.js {render :update do |page|
        page.redirect_to :action => 'show', :id => @group
      end}
    end
  end
  
  

  
  
end
