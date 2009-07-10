class SmartGroupPropertiesController < ApplicationController
  
    before_filter :login_required
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @smart_group_properties_pages, @smart_group_properties = paginate :smart_group_properties, :per_page => 10
  end

  def show
    @smart_group_property = SmartGroupProperty.find(params[:id])
  end

  def new
    @smart_group_property = SmartGroupProperty.new
  end

  def create
    @smart_group_property = SmartGroupProperty.new(params[:smart_group_property])
    if @smart_group_property.save
      flash[:notice] = 'SmartGroupProperty was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @smart_group_property = SmartGroupProperty.find(params[:id])
  end

  def update
    @smart_group_property = SmartGroupProperty.find(params[:id])
    if @smart_group_property.update_attributes(params[:smart_group_property])
      flash[:notice] = 'SmartGroupProperty was successfully updated.'
      redirect_to :action => 'show', :id => @smart_group_property
    else
      render :action => 'edit'
    end
  end

  def destroy
    SmartGroupProperty.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_operator
    @operator = Operator.new(:prose => params[:operator][:prose],
                             :short => params[:operator][:short])
    @smart_group_property = SmartGroupProperty.find(params[:property_id])
    
    if @smart_group_property.operators << @operator
      flash[:notice] = "New operator was added to this property."
      redirect_to :action => 'show', :id => @smart_group_property
    else
      render :action => 'show', :id => @smart_group_property
    end
  end
end
