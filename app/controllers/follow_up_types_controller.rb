class FollowUpTypesController < ApplicationController

    before_filter :login_required


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @follow_up_type_pages, @follow_up_types = paginate :follow_up_types, :per_page => 10
  end

  def show
    @follow_up_type = FollowUpType.find(params[:id])
  end

  def new
    @follow_up_type = FollowUpType.new
  end

  def create
    @follow_up_type = FollowUpType.new(params[:follow_up_type])
    if @follow_up_type.save
      flash[:notice] = 'FollowUpType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @follow_up_type = FollowUpType.find(params[:id])
  end

  def update
    @follow_up_type = FollowUpType.find(params[:id])
    if @follow_up_type.update_attributes(params[:follow_up_type])
      flash[:notice] = 'FollowUpType was successfully updated.'
      redirect_to :action => 'show', :id => @follow_up_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    FollowUpType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
