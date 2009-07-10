class RequirementsController < ApplicationController

    before_filter :login_required


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @requirement_pages, @requirements = paginate :requirements, :per_page => 10
  end

  def show
    @requirement = Requirement.find(params[:id])
  end

  def new
    @requirement = Requirement.new
  end

  def create
    @requirement = Requirement.new(params[:requirement])
    if @requirement.save
      flash[:notice] = 'Requirement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @requirement = Requirement.find(params[:id])
  end

  def update
    @requirement = Requirement.find(params[:id])
    if @requirement.update_attributes(params[:requirement])
      flash[:notice] = 'Requirement was successfully updated.'
      redirect_to :action => 'show', :id => @requirement
    else
      render :action => 'edit'
    end
  end

  def destroy
    Requirement.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
