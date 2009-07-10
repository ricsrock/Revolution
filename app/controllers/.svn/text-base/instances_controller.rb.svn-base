class InstancesController < ApplicationController
  
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @instances = Instance.find(:all)
    @instance_pages, @instances = paginate :instances, :per_page => 10
  end

  def show
    @instance = Instance.find(params[:id])
  end

  def new
    @instance = Instance.new
  end

  def create
    @instance = Instance.new(params[:instance])
    if @instance.save
      flash[:notice] = 'Instance was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @instance = Instance.find(params[:id])
  end

  def update
    @instance = Instance.find(params[:id])
    if @instance.update_attributes(params[:instance])
      flash[:notice] = 'Instance was successfully updated.'
      redirect_to :action => 'show', :id => @instance
    else
      render :action => 'edit'
    end
  end

  def destroy
    Instance.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_meeting
    @group = Group.find(params[:meeting][:group_id])
    @meeting = Meeting.new(
                            :instance_id => params['id'],
                            :group_id => params[:meeting][:group_id],
                            :room_id => @group.default_room.id)
    if @meeting.save
      flash[:notice] = 'The meeting was successfully added to this instance.'
    end
    redirect_to(:back)
  end
  
  def stats
    @instance = Instance.find(params[:id])
  end
end
