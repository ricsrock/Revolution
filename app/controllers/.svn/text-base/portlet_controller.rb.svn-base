class PortletController < ApplicationController
  
  before_filter :login_required, :except => :login
  layout 'portlet'

  def index
    go_here = request.request_uri
    cookies[:login] = { :value => "portlet" }
  end
  
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    cookies[:portlet] = 'portlet'
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_to :controller => 'portlet', :action => 'index'
      flash[:notice] = "Logged into portlet successfully"
    else
      flash[:notice] = "Couldn't log you in."
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out of the portlet."
    redirect_to(:controller => 'portlet', :action => 'login')
  end
  
  def show_group
    @group = Group.find(params[:id])
    flash[:notice] = ''
  end
  
  def email_group
    @group = Group.find(params[:id])
  end
  
  def new_meeting
    @group = Group.find(params[:id])
  end
  
  def send_email
    @sent = []
    @not_sent = []
    @message = []
    @people = []
    subject = params[:email][:subject]
    message = params[:email][:message]
    current_user_email = current_user.email
    @group = Group.find(params[:id])
    params[:included_people].each do |p|
      @people << Person.find(p)
    end
    @people.each do |person|
        VolunteerMailer.deliver_group_contact_portlet(subject, message, person, current_user_email)
    end
    @color = 'green'
    flash[:notice] = "The message has been sent."
  end
  
  def home
    @group = Group.find(params[:id])
  end
  
  def event_type_changed
    @event_type = EventType.find(params[:id])
    render :partial => 'select_instance_type', :locals => { :event_type => @event_type }
  end
  
  def add_meeting
    @group = Group.find(params[:group_id])
    @color = 'green'
    @errors = []
    @errors << "You must choose a date. <br>" if params[:meeting][:real_date].blank?
    @errors << "Please select an Instance Type. <br>" if params[:instance_type][:id].blank?
    if @errors.empty?
      recent_sunday = (params[:meeting][:real_date].to_date) - (params[:meeting][:real_date].to_date.wday) if params[:meeting][:real_date]
      @event = Event.find_or_create_by_event_type_id_and_date(params[:event_type][:id], recent_sunday)
      @instance = Instance.find_by_instance_type_id_and_event_id(params[:instance_type][:id], @event.id) if params[:instance_type][:id]
      @meeting = Meeting.new(:instance_id => @instance.id,
                             :group_id => params[:group_id],
                             :room_id => @group.default_room_id,
                             :real_date => params[:meeting][:real_date],
                             :comments => params[:meeting][:comments],
                             :created_by => current_user.login)
      if @meeting.save
          flash[:notice] = 'Meeting was successfully created. Thank you for making a difference!'
    
          params[:present_people].each do |p|
            Attendance.create(:meeting_id => @meeting.id,
                          :person_id => p,
                          :checkin_time => Time.now,
                          :checkout_time => Time.now)
          end
      else
        @errors << "The meeting could not be saved."
        @color = 'red'
        @blah = []
        @blah << "Could not save your meeting. <br>"
        @meeting.errors.each_full {|e| @blah << e}
        flash[:notice] = @blah
      end
    else
      @color = 'red'
      flash[:notice] = @errors.each {|e| e}
    end
  end
  
  def cancel_new_meeting
    @group = Group.find(params[:id])
  end
  
  def roster
    @group = Group.find(params[:id])
  end
  
end
