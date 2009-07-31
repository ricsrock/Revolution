class SmsSetupsController < ApplicationController
    
    before_filter :login_required

      require_role ["checkin_user", "supervisor"]
      require_role "admin", :only => [:destroy]
    
    layout 'inner'
    
    
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @sms_setups = SmsSetup.paginate :page => params[:page], :per_page => 10
  end

  def show
    @sms_setup = SmsSetup.find(params[:id])
  end

  def new
    @sms_setup = SmsSetup.new
  end

  def create
    params[:sms_setup][:created_by] = current_user.login
    @sms_setup = SmsSetup.new(params[:sms_setup])
    if @sms_setup.save
      flash[:notice] = 'SmsSetup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sms_setup = SmsSetup.find(params[:id])
  end

  def update
    params[:sms_setup][:updated_by] = current_user.login
    @sms_setup = SmsSetup.find(params[:id])
    if @sms_setup.update_attributes(params[:sms_setup])
      flash[:notice] = 'SmsSetup was successfully updated.'
      redirect_to :action => 'show', :id => @sms_setup
    else
      render :action => 'edit'
    end
  end

  def destroy
    SmsSetup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
