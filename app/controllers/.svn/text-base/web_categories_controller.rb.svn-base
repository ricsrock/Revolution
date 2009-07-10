class WebCategoriesController < ApplicationController
  
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
    @web_category_pages, @web_categories = paginate :web_categories, :per_page => 10
  end

  def show
    @web_category = WebCategory.find(params[:id])
  end

  def new
    @web_category = WebCategory.new
  end

  def create
    params[:web_category][:created_by] = current_user.login
    @web_category = WebCategory.new(params[:web_category])
    if @web_category.save
      flash[:notice] = 'WebCategory was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @web_category = WebCategory.find(params[:id])
  end

  def update
    params[:web_category][:updated_by] = current_user.login
    @web_category = WebCategory.find(params[:id])
    if @web_category.update_attributes(params[:web_category])
      flash[:notice] = 'WebCategory was successfully updated.'
      redirect_to :action => 'show', :id => @web_category
    else
      render :action => 'edit'
    end
  end

  def destroy
    WebCategory.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
