class MilestonesController < ApplicationController

    before_filter :login_required


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @milestone_pages, @milestones = paginate :milestones, :per_page => 10
  end

  def show
    @milestone = Milestone.find(params[:id])
  end

  def new
    @milestone = Milestone.new
  end

  def create
    @milestone = Milestone.new(params[:milestone])
    if @milestone.save
      flash[:notice] = 'Milestone was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @milestone = Milestone.find(params[:id])
  end

  def update
    @milestone = Milestone.find(params[:id])
    if @milestone.update_attributes(params[:milestone])
      flash[:notice] = 'Milestone was successfully updated.'
      redirect_to :action => 'show', :id => @milestone
    else
      render :action => 'edit'
    end
  end

  def destroy
    Milestone.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
