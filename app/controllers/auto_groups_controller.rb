class AutoGroupsController < ApplicationController
  
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @auto_group_pages, @auto_groups = paginate :auto_groups, :per_page => 10
  end

  def show
    @auto_group = AutoGroup.find(params[:id])
  end

  def new
    @auto_group = AutoGroup.new
  end

  def create
    @auto_group = AutoGroup.new(params[:auto_group])
    if @auto_group.save
      flash[:notice] = 'AutoGroup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @auto_group = AutoGroup.find(params[:id])
  end

  def update
    @auto_group = AutoGroup.find(params[:id])
    if @auto_group.update_attributes(params[:auto_group])
      flash[:notice] = 'AutoGroup was successfully updated.'
      redirect_to :action => 'show', :id => @auto_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    AutoGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
