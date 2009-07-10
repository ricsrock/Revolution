class MinistriesController < ApplicationController
  
    before_filter :login_required


  require_role "supervisor"
  require_role "admin", :only => [:edit, :update], :unless => "current_user.authorized_for_ministry?(params[:id].to_s)"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @ministry_pages, @ministries = paginate :ministries, :per_page => 10
  end

  def show
    @ministry = Ministry.find(params[:id])
  end

  def new
    @ministry = Ministry.new(:department_id => params[:department_id])
  end

  def create
    params[:ministry][:created_by] = current_user.login
    @ministry = Ministry.new(params[:ministry])
    if @ministry.save
      flash[:notice] = 'Ministry was successfully created.'
      redirect_to :controller => 'departments', :action => 'show', :id => @ministry.department
    else
      render :action => 'new'
    end
  end

  def edit
    @ministry = Ministry.find(params[:id])
  end

  def update
    params[:ministry][:updated_by] = current_user.login
    @ministry = Ministry.find(params[:id])
    if @ministry.update_attributes(params[:ministry])
      flash[:notice] = 'Ministry was successfully updated.'
      redirect_to :action => 'show', :id => @ministry
    else
      render :action => 'edit'
    end
  end

  def destroy
    Ministry.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def delete_department
    Department.find(params[:id]).destroy
    @departments = Department.find(:all)
    department_id = "%"
    @ministries = Ministry.find_by_department_id(department_id)
    ministry_id = "%"
    @found_teams = Team.find_by_ministry_id(ministry_id)
  end
  
  def manage
    @departments = Department.find(:all)
    department_id = "%"
    @ministries = Ministry.find_by_department_id(department_id)
    ministry_id = "%"
    @found_teams = Team.find_by_ministry_id(ministry_id)
  end
  
  def department_changed
    department_id = params[:id]
    @ministries = Ministry.find_by_department_id(department_id)
    @department = Department.find(params[:id])
    @found_teams = @department.teams
  end
  
  def ministry_changed
    ministry_id = params[:id]
    @found_teams = Team.find_by_ministry_id(ministry_id)
  end
  
end
