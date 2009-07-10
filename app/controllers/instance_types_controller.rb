class InstanceTypesController < ApplicationController
  
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @instance_type_pages, @instance_types = paginate :instance_types, :per_page => 10
  end

  def show
    @instance_type = InstanceType.find(params[:id])
  end

  def new
    @instance_type = InstanceType.new
  end

  def create
    @instance_type = InstanceType.new(params[:instance_type])
    if @instance_type.save
      flash[:notice] = 'InstanceType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @instance_type = InstanceType.find(params[:id])
  end

  def update
    @instance_type = InstanceType.find(params[:id])
    if @instance_type.update_attributes(params[:instance_type])
      flash[:notice] = 'InstanceType was successfully updated.'
      redirect_to :action => 'show', :id => @instance_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    InstanceType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_auto_group
    @auto_group = AutoGroup.new(:instance_type_id => params[:id],
                                :group_id => params[:auto_group][:group_id])
    @auto_group.save
    redirect_to(:back)
  end
  
end
