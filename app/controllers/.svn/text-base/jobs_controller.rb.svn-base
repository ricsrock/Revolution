class JobsController < ApplicationController
  

    before_filter :login_required


  require_role "supervisor"
  require_role "admin", :only => [:edit, :update], :unless => "current_user.authorized_for_ministry?(Job.find(params[:id]).team.ministry.id.to_s)"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @job_pages, @jobs = paginate :jobs, :per_page => 10
  end

  def show
    @job = Job.find(params[:id])
    @found_people = Person.find(:all, :limit => 10)
    @checkin_types = CheckinType.find(:all)
  end

  def new
    @job = Job.new(:team_id => params[:team_id])
  end

  def create
    params[:job][:created_by] = current_user.login
    @job = Job.new(params[:job])
    if @job.save
      flash[:notice] = 'Job was successfully created.'
      redirect_to :controller => 'teams', :action => 'show', :id => @job.team
    else
      render :action => 'new'
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    params[:job][:updated_by] = current_user.login
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = 'Job was successfully updated.'
      redirect_to :controller => 'teams', :action => 'show', :id => @job.team
    else
      render :action => 'edit'
    end
  end

  def destroy
    Job.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def search
    names = params[:person_name].split(',')
    if names.length == 1
      conditions = ['last_name LIKE ?', params[:person_name].strip + '%']
    elsif names.length >= 2
      conditions = ['first_name LIKE ? AND last_name LIKE ?', names[1].strip + '%', names[0].strip + '%']
    end
    @found_people = Person.find(:all, :conditions => conditions, :limit => 5)
    @checkin_types = CheckinType.find(:all)
    @job= Job.find(params[:job_id])
  end
  
  def assign_to_job
    @job = Job.find(params[:job_id])
    @involvement = Involvement.new(:person_id => params[:person_id], :job_id => @job.id,
                                   :created_at => Time.now, :start_date => Date.today)
    if @involvement.save
        flash[:notice] = "#{@involvement.person.full_name} has been assigned to the job: #{@job.title}."
    else
        flash[:notice] = "That person couldn't be assigned to this job."
    end
  end
  
  def undo_involvement
    @involvement = Involvement.find(params[:id])
    if @involvement.destroy
        flash[:notice] = 'Involvement record was destroyed forever.'
    else
        flash[:notice] = 'Could not destroy involvement record. Sorry.'
    end
    @job = Job.find(params[:job_id])
  end
  
end
