class AssignmentsController < ApplicationController

    before_filter :login_required


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @assignment_pages, @assignments = paginate :assignments, :per_page => 10
  end

  def show
    @assignment = Assignment.find(params[:id])
  end

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      flash[:notice] = 'Assignment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = 'Assignment was successfully updated.'
      redirect_to :action => 'show', :id => @assignment
    else
      render :action => 'edit'
    end
  end

  def destroy
    Assignment.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def manage
    @month = (params[:month] || Time.now.month).to_i
    @year = (params[:year] || Time.now.year).to_i
    @assignments = Assignment.find(:all)
    @departments = Department.find(:all)
    @found_staff = Involvement.find(:all)
    @meeting = Meeting.find(:first)
    @set_meeting = Meeting.find(:first)
    session[:set_month] = (params[:month] || Time.now.month).to_i
    session[:set_year] = (params[:year] || Time.now.year).to_i
    
  end
  
  def month
   # @response.time_to_live = Time.now.tomorrow.midnight - Time.now
    @month = (params[:month] || Time.now.month).to_i
    @year = (params[:year] || Time.now.year).to_i
    @assignments = Assignment.find(:all)
    session[:set_month] = (params[:month] || Time.now.month).to_i
    session[:set_year] = (params[:year] || Time.now.year).to_i
  end
  
  def department_changed
      render :partial => "select_ministry", :locals => { :department_id => params[:id]}
  end
  
  def ministry_changed
    session[:set_ministry] = params[:id]
      render :partial => "select_team", :locals => { :ministry_id => params[:id]}
  end
  
  def set_team
    @set_team = Team.find(params[:id])
    session[:set_team] = Team.find(params[:id])
    @month, session[:set_month] = (params[:month] || Time.now.month).to_i
    @year, session[:set_year] = (params[:year] || Time.now.year).to_i
  end
  
  def add_assignment
   @assignment = Assignment.new(:involvement_id => params[:involvement_id],
                                 :meeting_id => params[:meeting_id])
   if @assignment.save
     flash[:notice] = 'Appointment has been scheduled.'
   end
   @month = (params[:month] || Time.now.month).to_i
   @year = (params[:year] || Time.now.year).to_i
   @assignments = Assignment.find(:all)
  end
  
  def delete_assignment
    Assignment.find(params[:id]).destroy
    @month = @session[:set_month]
    @year = @session[:set_year]
    flash[:notice] = "Assignment was successfully deleted."
  end
  
  def assign
    require 'enumerator'
    @created = 0
    @not_created = 0 
    @rotation = Rotation.find(params[:rotation_id])
    @found_meetings = Meeting.find_by_assignment_form(params[:instance][:type_id], params[:group][:id], params[:start][:date], @rotation.weeks_on)
    @found_meetings.each do |m|
      @rotation.deployments.each do |d|
        @assignment = Assignment.new(:involvement_id => d.involvement.id, :meeting_id => m.id)
        if @assignment.save
          @created += 1
        else
          @not_created += 1
        end
      end
    end
    @potential = (@found_meetings.length * @rotation.deployments.length)
    @month = (session[:set_month] || Time.now.month).to_i
    @year = (session[:set_year] || Time.now.year).to_i
    @message = []
    @message << @found_meetings.length << " matching meetings were found." << "<br>" <<
                "Out of " << @potential << " potential assignments..." << "<br>" <<
                @created << " assignments were created." << "<br>" <<
                @not_created << " assignments were not created because of duplication."
    flash[:notice] = @message
  end
  
  def reminder_call_list
    @team_id = params[:team_id]
    @message = []
    flash[:notice] = []
  end
  
  def schedule_mailer
    @team = Team.find(params[:team_id])
    @team_id = params[:team_id]
    @message = []
    flash[:notice] = []
  end
  
end
