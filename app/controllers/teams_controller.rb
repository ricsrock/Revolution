class TeamsController < ApplicationController
  
  require_role "supervisor"
  require_role "admin", :only => [:edit, :update], :unless => "current_user.authorized_for_ministry?(Team.find(params[:id]).ministry.id.to_s)"
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @team_pages, @teams = paginate :teams, :per_page => 10
  end

  def show
    session[:team_partial] ||= "jobs_tab"
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new(:ministry_id => params[:ministry_id])
  end

  def create
    params[:team][:created_by] = current_user.login
    @team = Team.new(params[:team])
    if @team.save
      flash[:notice] = 'Team was successfully created.'
      redirect_to :controller => 'ministries', :action => 'show', :id => @team.ministry
    else
      render :action => 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    params[:team][:updated_by] = current_user.login
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash[:notice] = 'Team was successfully updated.'
      redirect_to :action => 'show', :id => @team
    else
      render :action => 'edit'
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def show_roster_panel
    @team = Team.find(params[:team])
  end
  
  def show_rotations_panel
    @team = Team.find(params[:team])
  end
  
  def create_service_link
    @service_link = ServiceLink.new(:team_id => params[:team_id],
                                    :group_id => params[:group][:id])
    @service_link.save
    @team = Team.find(params[:team_id])
  end
  
  def delete_service_link
    ServiceLink.find(params[:id]).destroy
    @team = Team.find(params[:team_id])
  end
  
  def phone_list
    @team = Team.find(params[:team_id])
    flash[:notice] = []
  end
  
  def delete_job
    @job = Job.find(params[:id])
    if @job.involvements.empty?
        if @job.destroy
            flash[:notice] = 'Job record was destroyed forever.'
        else
            flash[:notice] = 'Job could not be destroyed for some reason. Sorry.'
        end
    else
        flash[:notice] = 'This job cannot be destroyed because it has people involved.'
    end
    @team = Team.find(params[:team_id])
  end
  
  def change_partial
    @team = Team.find(params[:team_id])
    @new_partial = params[:new_partial]
    session[:team_partial] = @new_partial
  end
  
  def new_team_contact
    @team = Team.find(params[:id])
  end
  
  def send_team_contact
      @sent = []
      @not_sent = []
      @message = []
      @people = []
      subject = params[:email][:subject]
      message = params[:email][:message]
      current_user_email = current_user.email
      team = Team.find(params[:team_id])
      params[:included_people].each do |p|
        @people << Person.find(p)
      end
      @people.each do |person|
          VolunteerMailer.deliver_team_contact(subject, message, person, current_user_email, team)
      end
      @message = 'Emails sent.'
      flash[:notice] = @message
      redirect_to :action => 'show', :id => team
    end
  
end
