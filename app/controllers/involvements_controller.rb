class InvolvementsController < ApplicationController

    before_filter :login_required
    require_role ["checkin_user","supervisor"]


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @involvement_pages, @involvements = paginate :involvements, :per_page => 10
  end

  def show
    @involvement = Involvement.find(params[:id])
  end

  def new
    @involvement = Involvement.new
  end

  def create
    @involvement = Involvement.new(params[:involvement])
    if @involvement.save
      flash[:notice] = 'Involvement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @involvement = Involvement.find(params[:id])
  end

  def update
    @involvement = Involvement.find(params[:id])
    if @involvement.update_attributes(params[:involvement])
      flash[:notice] = 'Involvement was successfully updated.'
      redirect_to :controller => 'jobs', :action => 'show', :id => @involvement.job
    else
      render :action => 'edit'
    end
  end

  def destroy
    Involvement.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def department_chosen
    @department = Department.find(params[:department_id])
    @ministry = '%'
    @team = '%'
  end
  
  def ministry_chosen
    @ministry = Ministry.find(params[:ministry_id])
    @team = '%'
    @department = '%'
  end
  
  def team_chosen
    @team = Team.find(params[:team_id])
    @department = '%'
    @ministry = '%'
  end
  
end
