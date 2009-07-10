class EventTypesController < ApplicationController
  
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @event_type_pages, @event_types = paginate :event_types, :per_page => 10
  end

  def show
    @event_type = EventType.find(params[:id])
  end

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(params[:event_type])
    if @event_type.save
      flash[:notice] = 'EventType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @event_type = EventType.find(params[:id])
  end

  def update
    @event_type = EventType.find(params[:id])
    if @event_type.update_attributes(params[:event_type])
      flash[:notice] = 'EventType was successfully updated.'
      redirect_to :action => 'show', :id => @event_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    EventType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_auto_instance_type
    @auto_instance = AutoInstanceType.new(:event_type_id => params[:id],
                                          :instance_type_id => params[:auto_instance_type][:instance_type_id])
    @auto_instance.save
    redirect_to(:back)
  end
end
