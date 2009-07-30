class SettingsController < ApplicationController
  
  before_filter :login_required
  
  require_role "admin", :only => [:edit, :show, :destroy, :new, :create, :update]
  
  layout 'inner'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def setup
    
  end
  
  def list
    #@setting_pages, @settings = paginate :settings, :per_page => 10
  end

  def show
    @setting = Setting.find(params[:id])
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      flash[:notice] = 'Setting was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @setting = Setting.find(params[:id])
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes(params[:setting])
      flash[:notice] = 'Setting was successfully updated.'
      redirect_to :action => 'show', :id => @setting
    else
      render :action => 'edit'
    end
  end

  def destroy
    Setting.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def select_event_type
    @event_type = EventType.find(params[:id])
  end
  
  def select_instance_type
    @instance_type = InstanceType.find(params[:id])
  end
  
  def new_event_type
    EventType.new
  end
  
  def new_instance_type
    InstanceType.new
  end
  
  def create_event_type
    @event_type = EventType.new(params[:event_type])
    @event_type.save
  end
  
  def create_instance_type
    @instance_type = InstanceType.new(params[:instance_type])
    @instance_type.save
  end
  
  def delete_event_type
    EventType.find(params[:id]).destroy
  end
  
  def delete_instance_type
    InstanceType.find(params[:id]).destroy
  end
  
  def show_add_auto_instance_form
    @event_type = EventType.find(params[:event_type])
  end
  
  def show_add_auto_group_form
    @instance_type = InstanceType.find(params[:instance_type])
  end
  
  def add_auto_instance_type
    @auto_instance = AutoInstanceType.new(:event_type_id => params[:event_type],
                                          :instance_type_id => params[:auto_instance_type][:instance_type_id])
    @auto_instance.save
    @event_type = EventType.find(params[:event_type])
  end
  
  def add_auto_group
    @auto_group = AutoGroup.new(:instance_type_id => params[:instance_type],
                                          :group_id => params[:auto_group][:group_id])
    @auto_group.save
    @instance_type = InstanceType.find(params[:instance_type])
  end
  
  def delete_auto_instance_type
    AutoInstanceType.find(params[:id]).destroy
  end
  
end
