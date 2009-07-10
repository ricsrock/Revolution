class RotationsController < ApplicationController

    before_filter :login_required


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @rotation_pages, @rotations = paginate :rotations, :per_page => 10
  end

  def show
    @rotation = Rotation.find(params[:id])
    @team = Team.find(@rotation.team)
    flash[:notice] = []
  end

  def new
    @rotation = Rotation.new(:team_id => params[:team_id])
  end

  def create
    @rotation = Rotation.new(params[:rotation])
    if @rotation.save
      flash[:notice] = 'Rotation was successfully created.'
      redirect_to :controller => 'teams', :action => 'show', :id => @rotation.team
    else
      render :action => 'new'
    end
  end

  def edit
    @rotation = Rotation.find(params[:id])
  end

  def update
    @rotation = Rotation.find(params[:id])
    if @rotation.update_attributes(params[:rotation])
      flash[:notice] = 'Rotation was successfully updated.'
      redirect_to :action => 'show', :id => @rotation
    else
      render :action => 'edit'
    end
  end

  def destroy
    Rotation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
