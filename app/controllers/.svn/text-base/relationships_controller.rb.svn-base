class RelationshipsController < ApplicationController
  
  before_filter :login_required

   require_role "supervisor"
   require_role "admin", :only => [:destroy]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @relationship_pages, @relationships = paginate :relationships, :per_page => 10
  end

  def show
    @relationship = Relationship.find(params[:id])
  end

  def new
    @relationship = Relationship.new
  end

  def create
    params[:relationship][:created_by] = current_user.login
    params[:relationship][:person_id] = params[:person_id]
    if params[:relationship][:inactive] == "1"
      params[:relationship][:deactived_on] = Time.now
    end
    params[:relationship].delete(:inactive)
    params[:relationship][:created_by] = current_user.login
    params[:relationship][:created_at] = Time.now
    @relationship = Relationship.new(params[:relationship])
    if @relationship.save
      flash[:notice] = 'Relationship was successfully created.'
    else
      flash[:notice] = 'Relationship could not be created, sorry.'
    end
    #redirect_to :controller => 'people', :action => 'show', :id => @relationship.person_id
  end

  def edit
    @relationship = Relationship.find(params[:id])
  end

  def update
    @relationship = Relationship.find(params[:id])
    if @relationship.update_attributes(params[:relationship])
      flash[:notice] = 'Relationship was successfully updated.'
      redirect_to :action => 'show', :id => @relationship
    else
      render :action => 'edit'
    end
  end

  def destroy
    Relationship.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
