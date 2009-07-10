class MeetingsController < ApplicationController
  
  before_filter :login_required
  require_role ["checkin_user", "supervisor"]
  require_role "supervisor", :only => :destroy
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @meeting_pages, @meetings = paginate :meetings, :per_page => 10
  end

  def show
    @meeting = Meeting.find(params[:id])
  end

  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(params[:meeting])
    if @meeting.save
      flash[:notice] = 'Meeting was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    @meeting = Meeting.find(params[:id])
    if @meeting.update_attributes(params[:meeting])
      flash[:notice] = 'Meeting was successfully updated.'
      redirect_to :action => 'detail', :id => @meeting
    else
      render :action => 'edit'
    end
  end

  def destroy
    Meeting.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def checkout_all
    @this_one = Meeting.find(params[:id])
    @this_one.active_attendances.each do |x|
      x.update_attributes(:checkout_time => Time.now)
    end
    @meeting = @this_one
    @meeting.active_attendances.reload
  end
  
  def detail
    @meeting = Meeting.find(params[:id])
    @found_people = Person.find(:all, :order => ['last_name, first_name ASC'], :limit => 5)
    @checkin_types = CheckinType.find(:all)
  end
  
  def add_attendance
    letters = ("A".."Z").to_a
    numbers = ("0".."9").to_a
    newcode = ""
    3.times {|i| newcode << letters[rand(letters.size-1)]}
    3.times {|i| newcode << numbers[rand(numbers.size-1)]}
    
    @meeting = Meeting.find(params[:meeting_id])
    
    @attendance = Attendance.new(:checkin_time => Time.now,
                                 :checkout_time => Time.now,
                                 :person_id => params[:person_id],
                                 :checkin_type_id => params[:attendance][:checkin_type_id],
                                 :security_code => newcode)
    @meeting.attendances << @attendance
    @person = Person.find(params[:person_id])
  end
  
  def search
    names = params[:person_name].split(',')
    if names.length == 1
      conditions = ['last_name LIKE ?', params[:person_name].strip + '%']
    elsif names.length >= 2
      conditions = ['first_name LIKE ? AND last_name LIKE ?', names[1].strip + '%', names[0].strip + '%']
    end
    @found_people = Person.find(:all, :conditions => conditions, :order => ['last_name, first_name ASC'], :limit => 9)
    @checkin_types = CheckinType.find(:all)
    @meeting = Meeting.find(params[:meeting_id])
  end
  
  def mark
    @meeting = Meeting.find(params[:id])
  end
  
  def mark_selected
    @meeting = Meeting.find(params[:meeting_id])
    params[:present_people].each do |p|
        @a = Attendance.new(:meeting_id => @meeting.id,
                           :person_id => p,
                           :checkin_time => Time.now,
                           :checkout_time => Time.now,
                           :checkin_type_id => 1)
        @a.save
       end
     flash[:notice] = "Meeting attendance has been updated."
     redirect_to :controller => 'groups', :action => 'show', :id => @meeting.group.id
  end
  
end
