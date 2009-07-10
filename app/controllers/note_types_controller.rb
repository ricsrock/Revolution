class NoteTypesController < ApplicationController
  
  layout 'inner'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @note_type_pages, @note_types = paginate :note_types, :per_page => 10
  end

  def show
    @note_type = NoteType.find(params[:id])
  end

  def new
    @note_type = NoteType.new
  end

  def create
    params[:note_type][:created_by] = current_user.login
    @note_type = NoteType.new(params[:note_type])
    if @note_type.save
      flash[:notice] = 'NoteType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @note_type = NoteType.find(params[:id])
  end

  def update
    params[:note_type][:updated_by] = current_user.login
    @note_type = NoteType.find(params[:id])
    if @note_type.update_attributes(params[:note_type])
      flash[:notice] = 'NoteType was successfully updated.'
      redirect_to :action => 'show', :id => @note_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    NoteType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
