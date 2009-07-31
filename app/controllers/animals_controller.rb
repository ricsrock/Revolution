class AnimalsController < ApplicationController
  
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
    @animals = Animal.paginate :page => params[:page], :per_page => 30, :order => :name
  end

  def show
    @animal = Animal.find(params[:id])
  end

  def new
    @animal = Animal.new
  end

  def create
    params[:animal][:created_by] = current_user.login
    @animal = Animal.new(params[:animal])
    if @animal.save
      flash[:notice] = 'Animal was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @animal = Animal.find(params[:id])
  end

  def update
    params[:animal][:updated_by] = current_user.login
    @animal = Animal.find(params[:id])
    if @animal.update_attributes(params[:animal])
      flash[:notice] = 'Animal was successfully updated.'
      redirect_to :action => 'show', :id => @animal
    else
      render :action => 'edit'
    end
  end

  def destroy
    Animal.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
