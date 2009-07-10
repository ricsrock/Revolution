class DepartmentsController < ApplicationController
  
    before_filter :login_required


  require_role "supervisor"
  require_role "admin", :only => :destroy
    
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @department_pages, @departments = paginate :departments, :per_page => 10
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new
  end

  def create
    params[:department][:created_by] = current_user.login
    @department = Department.new(params[:department])
    if @department.save
      flash[:notice] = 'Department was successfully created.'
      redirect_to :action => 'show', :id => @department.id
    else
      render :action => 'new'
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    params[:department][:updated_by] = current_user.login
    @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      flash[:notice] = 'Department was successfully updated.'
      redirect_to :action => 'show', :id => @department
    else
      render :action => 'edit'
    end
  end

  def destroy
    Department.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
