class DeploymentsController < ApplicationController

    before_filter :login_required


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @deployment_pages, @deployments = paginate :deployments, :per_page => 10
  end

  def show
    @deployment = Deployment.find(params[:id])
  end

  def new
    @deployment = Deployment.new
  end

  def create
    @deployment = Deployment.new(:involvement_id => params[:involvement_id],
                                :rotation_id => params[:rotation_id])
    @deployment.save
    @rotation = Rotation.find(params[:rotation_id])
  end

  def edit
    @deployment = Deployment.find(params[:id])
  end

  def update
    @deployment = Deployment.find(params[:id])
    if @deployment.update_attributes(params[:deployment])
      flash[:notice] = 'Deployment was successfully updated.'
      redirect_to :action => 'show', :id => @deployment
    else
      render :action => 'edit'
    end
  end

  def destroy
    Deployment.find(params[:id]).destroy
    @rotation = Rotation.find(params[:rotation_id])
  end
end
