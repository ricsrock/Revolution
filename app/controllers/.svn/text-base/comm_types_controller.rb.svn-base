class CommTypesController < ApplicationController
  
  before_filter :login_required
  
  layout 'inner'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @comm_type_pages, @comm_types = paginate :comm_types, :per_page => 10
  end

  def show
    @comm_type = CommType.find(params[:id])
  end

  def new
    @comm_type = CommType.new
  end

  def create
    @comm_type = CommType.new(params[:comm_type])
    if @comm_type.save
      flash[:notice] = 'CommType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @comm_type = CommType.find(params[:id])
  end

  def update
    @comm_type = CommType.find(params[:id])
    if @comm_type.update_attributes(params[:comm_type])
      flash[:notice] = 'CommType was successfully updated.'
      redirect_to :action => 'show', :id => @comm_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    CommType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
