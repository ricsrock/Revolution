class ColorsController < ApplicationController
  
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
    @color_pages, @colors = paginate :colors, :per_page => 30, :order => :name
  end

  def show
    @color = Ccolor.find(params[:id])
  end

  def new
    @color = Ccolor.new
  end

  def create
    params[:color][:created_by] = current_user.login
    @color = Ccolor.new(params[:color])
    if @color.save
      flash[:notice] = 'Color was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @color = Ccolor.find(params[:id])
  end

  def update
    params[:color][:updated_by] = current_user.login
    @color = Ccolor.find(params[:id])
    if @color.update_attributes(params[:color])
      flash[:notice] = 'Color was successfully updated.'
      redirect_to :action => 'show', :id => @color
    else
      render :action => 'edit'
    end
  end

  def destroy
    Ccolor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
