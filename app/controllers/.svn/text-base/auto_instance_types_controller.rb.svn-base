class AutoInstanceTypesController < ApplicationController
  
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @auto_instance_type_pages, @auto_instance_types = paginate :auto_instance_types, :per_page => 10
  end

  def show
    @auto_instance_type = AutoInstanceType.find(params[:id])
  end

  def new
    @auto_instance_type = AutoInstanceType.new
  end

  def create
    @auto_instance_type = AutoInstanceType.new(params[:auto_instance_type])
    if @auto_instance_type.save
      flash[:notice] = 'AutoInstanceType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @auto_instance_type = AutoInstanceType.find(params[:id])
  end

  def update
    @auto_instance_type = AutoInstanceType.find(params[:id])
    if @auto_instance_type.update_attributes(params[:auto_instance_type])
      flash[:notice] = 'AutoInstanceType was successfully updated.'
      redirect_to :action => 'show', :id => @auto_instance_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    AutoInstanceType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
