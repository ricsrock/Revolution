class TagsController < ApplicationController
  
  before_filter :login_required
  layout 'inner', :except => ['inspector']
  require_role ["supervisor", "checkin_user"]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tag_pages, @tags = paginate :tags, :per_page => 10
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(:name => params[:tag][:name], :tag_group_id => params[:tag_group_id], :created_by => current_user.login)
    if @tag.save
      flash[:notice] = 'Tag was successfully created.'
    end
    @tag_group = TagGroup.find(params[:tag_group_id])
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      flash[:notice] = 'Tag was successfully updated.'
      redirect_to :action => 'show', :id => @tag
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tag.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def inspector
      @taggings = Tagging.find_by_tag_group(3, "Date ASC", "This Month", "")
      render :layout => 'application'
  end
  
  def filter
    @taggings = Tagging.find_by_tag_group(params[:filter][:tag_group_id],params[:filter][:sort], params[:filter][:range],params[:filter][:tag_id])
  end
  
  def tag_group_changed
    @tag_group = TagGroup.find(params[:id])
  end
end
