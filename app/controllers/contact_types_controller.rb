class ContactTypesController < ApplicationController
  
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
    @contact_types = ContactType.paginate(:page => params[:page], :order => ['name ASC'], :per_page => 20)
  end

  def show
    @contact_type = ContactType.find(params[:id])
  end

  def new
    @contact_type = ContactType.new
  end

  def create
    params[:contact_type][:created_by] = current_user.login
    @contact_type = ContactType.new(params[:contact_type])
    if @contact_type.save
      flash[:notice] = 'ContactType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @contact_type = ContactType.find(params[:id])
  end

  def update
    params[:contact_type][:updated_by] = current_user.login
    @contact_type = ContactType.find(params[:id])
    if @contact_type.update_attributes(params[:contact_type])
      flash[:notice] = 'ContactType was successfully updated.'
      redirect_to :action => 'show', :id => @contact_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    ContactType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
