class CheckinTypesController < ApplicationController
  
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
    @checkin_types = CheckinType.paginate :page => params[:page], :per_page => 10
  end

  def show
    @checkin_type = CheckinType.find(params[:id])
  end

  def new
    @checkin_type = CheckinType.new
  end

  def create
    @checkin_type = CheckinType.new(params[:checkin_type])
    if @checkin_type.save
      flash[:notice] = 'CheckinType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @checkin_type = CheckinType.find(params[:id])
  end

  def update
    @checkin_type = CheckinType.find(params[:id])
    if @checkin_type.update_attributes(params[:checkin_type])
      flash[:notice] = 'CheckinType was successfully updated.'
      redirect_to :action => 'show', :id => @checkin_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    CheckinType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
