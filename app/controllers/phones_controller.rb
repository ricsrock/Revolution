class PhonesController < ApplicationController
  
  before_filter :login_required
  require_role ["checkin_user", "supervisor"]
  require_role "supervisor", :only => :destroy
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @phone_pages, @phones = paginate :phones, :per_page => 10
  end

  def show
    @phone = Phone.find(params[:id])
  end

  def new
    @phone = Phone.new
  end

  def create
    @phone = Phone.new(params[:phone])
    if @phone.save
      flash[:notice] = 'Phone was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @phone = Phone.find(params[:id])
  end

  def update
    @phone = Phone.find(params[:id])
    if @phone.update_attributes(params[:phone])
      flash[:notice] = 'Phone was successfully updated.'
      redirect_to :action => 'show', :id => @phone
    else
      render :action => 'edit'
    end
  end

  def destroy
    Phone.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
