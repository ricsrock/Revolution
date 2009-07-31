class UsersController < ApplicationController
  
  before_filter :login_required
  layout 'inner'
  #require_role "supervisor"
  require_role "admin", :for_all_except => [:list, :show]
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @users = User.paginate(:page => params[:page], :order => ['last_name, first_name ASC'], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.role_ids = params[:user][:role_ids]
    @user.ministry_ids = params[:user][:ministry_ids]
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def search_user
    if params[:search_name].split(',').size > 1
      find_conditions = "last_name LIKE ? AND first_name LIKE ?"
      @users = User.find(:all, :conditions => [find_conditions, params[:search_name].split(',')[0].strip+'%',params[:search_name].split(',')[1].strip+'%'],
                         :order => ['last_name,first_name ASC'])
    else
      find_conditions = "last_name LIKE ?"
      @users = User.find(:all, :conditions => [find_conditions, params[:search_name].strip+'%'],
                          :order => ['last_name,first_name ASC'])
    end
  end
end
