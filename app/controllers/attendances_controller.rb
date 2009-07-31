class AttendancesController < ApplicationController
  
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
    @attendances = Attendance.paginate :page => params[:page], :per_page => 10
  end

  def show
    @attendance = Attendance.find(params[:id])
  end

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(params[:attendance])
    if @attendance.save
      flash[:notice] = 'Attendance was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.update_attributes(params[:attendance])
      flash[:notice] = 'Attendance was successfully updated.'
      redirect_to :action => 'show', :id => @attendance
    else
      render :action => 'edit'
    end
  end

  def destroy
    Attendance.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def destroy_rjs
    Attendance.find(params[:id]).destroy
    @meeting = Meeting.find(params[:meeting])
  end
  
  def checkout_all
    @all_active = Attendance.all_active
    @all_active.each do |a|
      a.checkout
    end
    redirect_to(:back)  
  end
  
end
