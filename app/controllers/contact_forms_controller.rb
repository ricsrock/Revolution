class ContactFormsController < ApplicationController
  
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
    @contact_forms = ContactForm.paginate :page => params[:page], :per_page => 10, :order => :name
  end

  def show
    @contact_form = ContactForm.find(params[:id])
  end

  def new
    @contact_form = ContactForm.new
  end

  def create
    params[:contact_form][:created_by] = current_user.login
    @contact_form = ContactForm.new(params[:contact_form])
    if @contact_form.save
      flash[:notice] = 'ContactForm was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @contact_form = ContactForm.find(params[:id])
  end

  def update
    params[:contact_form][:updated_by] = current_user.login
    @contact_form = ContactForm.find(params[:id])
    if @contact_form.update_attributes(params[:contact_form])
      flash[:notice] = 'ContactForm was successfully updated.'
      redirect_to :action => 'show', :id => @contact_form
    else
      render :action => 'edit'
    end
  end

  def destroy
    ContactForm.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_contact_type
    @contact_form = ContactForm.find(params[:id])
    @contact_type = ContactType.find(params[:contact_type_id])
    @contact_form.contact_types << @contact_type
    @contact_form.update_attributes(:updated_at => Time.now,:updated_by => current_user.login)
  end
  
  def remove_contact_type
    @contact_form = ContactForm.find(params[:id])
    @contact_type = ContactType.find(params[:contact_type_id])
    @contact_form.contact_types.delete(@contact_type)
    @contact_form.update_attributes(:updated_at => Time.now,:updated_by => current_user.login)
  end
end
