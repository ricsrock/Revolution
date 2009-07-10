class JobRequirementsController < ApplicationController

    before_filter :login_required


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @job_requirement_pages, @job_requirements = paginate :job_requirements, :per_page => 10
  end

  def show
    @job_requirement = JobRequirement.find(params[:id])
  end

  def new
    @job_requirement = JobRequirement.new
  end

  def create
    @job_requirement = JobRequirement.new(params[:job_requirement])
    if @job_requirement.save
      flash[:notice] = 'JobRequirement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @job_requirement = JobRequirement.find(params[:id])
  end

  def update
    @job_requirement = JobRequirement.find(params[:id])
    if @job_requirement.update_attributes(params[:job_requirement])
      flash[:notice] = 'JobRequirement was successfully updated.'
      redirect_to :action => 'show', :id => @job_requirement
    else
      render :action => 'edit'
    end
  end

  def destroy
    JobRequirement.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
