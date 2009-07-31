class RelationshipTypesController < ApplicationController
  
  layout 'inner'
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @relationship_types = RelationshipType.paginate :page => params[:page], :per_page => 10, :order => :name
  end

  def show
    @relationship_type = RelationshipType.find(params[:id])
  end

  def new
    @relationship_type = RelationshipType.new
  end

  def create
    params[:relationship_type][:created_by] = current_user.login
    @relationship_type = RelationshipType.new(params[:relationship_type])
    if @relationship_type.save
      flash[:notice] = 'RelationshipType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @relationship_type = RelationshipType.find(params[:id])
  end

  def update
    params[:relationship_type][:updated_by] = current_user.login
    @relationship_type = RelationshipType.find(params[:id])
    if @relationship_type.update_attributes(params[:relationship_type])
      flash[:notice] = 'RelationshipType was successfully updated.'
      redirect_to :action => 'show', :id => @relationship_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    RelationshipType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def add_role
    @role = RelationshipRole.new(:name => params[:relationship_role][:name],
                                 :created_by => current_user.login)
    @role.save
    @relationship_type = RelationshipType.find(params[:relationship_type_id])
    @relationship_type.relationship_roles << @role
  end
end
