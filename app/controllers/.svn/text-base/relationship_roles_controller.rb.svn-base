class RelationshipRolesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @relationship_role_pages, @relationship_roles = paginate :relationship_roles, :per_page => 10
  end

  def show
    @relationship_role = RelationshipRole.find(params[:id])
  end

  def new
    @relationship_role = RelationshipRole.new
  end

  def create
    @relationship_role = RelationshipRole.new(params[:relationship_role])
    if @relationship_role.save
      flash[:notice] = 'RelationshipRole was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @relationship_role = RelationshipRole.find(params[:id])
  end

  def update
    @relationship_role = RelationshipRole.find(params[:id])
    if @relationship_role.update_attributes(params[:relationship_role])
      flash[:notice] = 'RelationshipRole was successfully updated.'
      redirect_to :action => 'show', :id => @relationship_role
    else
      render :action => 'edit'
    end
  end

  def destroy
    RelationshipRole.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
