class AdjectivesController < ApplicationController
  
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
    @adjectives = Adjective.paginate :page => params[:page], :per_page => 30, :order => :name
  end

  def show
    @adjective = Adjective.find(params[:id])
  end

  def new
    @adjective = Adjective.new
  end

  def create
    params[:adjective][:created_by] = current_user.login
    @adjective = Adjective.new(params[:adjective])
    if @adjective.save
      flash[:notice] = 'Adjective was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @adjective = Adjective.find(params[:id])
  end

  def update
    params[:adjective][:updated_by] = current_user.login
    @adjective = Adjective.find(params[:id])
    if @adjective.update_attributes(params[:adjective])
      flash[:notice] = 'Adjective was successfully updated.'
      redirect_to :action => 'show', :id => @adjective
    else
      render :action => 'edit'
    end
  end

  def destroy
    Adjective.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
