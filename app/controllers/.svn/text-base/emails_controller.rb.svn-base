class EmailsController < ApplicationController
  
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
    @email_pages, @emails = paginate :emails, :per_page => 10
  end

  def show
    @email = Email.find(params[:id])
  end

  def new
    @email = Email.new
  end

  def create
    @email = Email.new(params[:email])
    if @email.save
      flash[:notice] = 'Email was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @email = Email.find(params[:id])
  end

  def update
    @email = Email.find(params[:id])
    if @email.update_attributes(params[:email])
      flash[:notice] = 'Email was successfully updated.'
      redirect_to :action => 'show', :id => @email
    else
      render :action => 'edit'
    end
  end

  def destroy
    Email.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
