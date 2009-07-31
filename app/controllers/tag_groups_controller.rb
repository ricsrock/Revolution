class TagGroupsController < ApplicationController
  
  layout 'inner'
  
  before_filter :login_required
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tag_groups = TagGroup.paginate :page => params[:page], :per_page => 10, :order => :name
  end

  def show
    @tag_group = TagGroup.find(params[:id])
  end

  def new
    @tag_group = TagGroup.new
  end

  def create
    @tag_group = TagGroup.new(:name => params[:tag_group][:name], :created_by => current_user.login)
    if @tag_group.save
      flash[:notice] = 'TagGroup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tag_group = TagGroup.find(params[:id])
  end

  def update
    @tag_group = TagGroup.find(params[:id])
    if @tag_group.update_attributes(:name => params[:tag_group][:name], :updated_by => current_user.login)
      flash[:notice] = 'TagGroup was successfully updated.'
      redirect_to :action => 'show', :id => @tag_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    TagGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
