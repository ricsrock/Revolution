class OrganizationsController < ApplicationController
  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @organizations = Organization.paginate :page => params[:page], :per_page => 10
  end

  def show
    @organization = Organization.find(params[:id], :include => [:phones, :emails, :associates])
    session[:original_uri] = request.request_uri
    current_user.set_preference(:organization_partial, "communication")
  end

  def new
    @organization = Organization.new
  end

  def create
    params[:organization][:created_by] = current_user.login
    @organization = Organization.new(params[:organization])
    if @organization.save
      flash[:notice] = 'Organization was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    params[:organization][:updated_by] = current_user.login
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(params[:organization])
      flash[:notice] = 'Organization was successfully updated.'
      redirect_to :action => 'show', :id => @organization
    else
      render :action => 'edit'
    end
  end

  def destroy
    Organization.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def code_address
    @organization = Organization.find(params[:id])
    @organization.update_attribute(:address, @organization.address_stamp)
    if @organization.pub_geocode_address
        flash[:notice] = "Address successfully geocoded."
    else
        flash[:notice] = "Address could not be geocoded."
    end
    redirect_to :action => 'show', :id => @organization
  end

  def change_partial
    @organization = Organization.find(params[:organization_id])
    @new_partial = params[:new_partial]
    current_user.set_preference!(:organization_partial, @new_partial)
    current_user.set_preference!(:organization_tab, params[:new_partial])
    @variable = params[:new_partial]
  end

  def add_an_email
    @organization = Organization.find(params[:organization_id])
    @email = Email.create(params[:email])
    @organization.emails << @email
    redirect_to :action => 'show', :id => @organization
  end

  def add_a_phone
    @organization = Organization.find(params[:organization_id])
    @phone = Phone.create(params[:phone])
    @organization.phones << @phone
    redirect_to :action => 'show', :id => @organization
  end

  def update_phones
    @organization = Organization.find(params[:id])
    @organization.phones.each { |p| p.attributes = params[:phone][p.id.to_s] }
    @organization.phones.each(&:save!)
    redirect_to :action => 'show', :id => @organization
  end
  
  def update_emails
    @organization = Organization.find(params[:id])
    @organization.emails.each { |p| p.attributes = params[:email][p.id.to_s] }
    @organization.emails.each(&:save!)
    redirect_to :action => 'show', :id => @organization
  end

  def delete_phone
    @organization = Organization.find(params[:organization])
    Phone.find(params[:id]).destroy
    redirect_to :action => 'show', :id => @organization
  end

  def delete_email
    @organization = Organization.find(params[:organization])
    Email.find(params[:id]).destroy
    redirect_to :action => 'show', :id => @organization
  end
  
  def add_an_associate
    params[:associate][:created_at] = Time.now
    params[:associate][:created_by] = current_user.login
    @organization = Organization.find(params[:organization_id])
    @associate = Associate.create(params[:associate])
    @organization.associates << @associate
    if @associate.save
      flash[:notice] = "Associate was successfully added to this organization."
      redirect_to :action => 'show', :id => @organization
    else
      flash[:notice] = "Associate could not be added. Please check the information and try again."
      @view = "display:block;"
      render :action => 'show', :id => @organization
    end
  end
end
