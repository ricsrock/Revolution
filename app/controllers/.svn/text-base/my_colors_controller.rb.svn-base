class MyColorsController < ApplicationController
  
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
    @my_color_pages, @my_colors = paginate :my_colors, :per_page => 30, :order => :name
  end

  def show
    @my_color = MyColor.find(params[:id])
  end

  def new
    @my_color = MyColor.new
  end

  def create
    params[:my_color][:created_by] = current_user.login
    @my_color = MyColor.new(params[:my_color])
    if @my_color.save
      flash[:notice] = 'MyColor was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @my_color = MyColor.find(params[:id])
  end

  def update
    params[:my_color][:updated_by] = current_user.login
    @my_color = MyColor.find(params[:id])
    if @my_color.update_attributes(params[:my_color])
      flash[:notice] = 'MyColor was successfully updated.'
      redirect_to :action => 'show', :id => @my_color
    else
      render :action => 'edit'
    end
  end

  def destroy
    MyColor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
