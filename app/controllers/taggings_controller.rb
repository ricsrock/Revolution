class TaggingsController < ApplicationController
  
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tagging_pages, @taggings = paginate :taggings, :per_page => 10
  end

  def show
    @tagging = Tagging.find(params[:id])
  end

  def new
    @tagging = Tagging.new
  end

  def create
    @tagging = Tagging.new(:person_id => params[:person_id], :tag_id => params[:tag][:id],
                                                             :created_by => current_user.login,
                                                             :start_date => params[:tagging][:start_date],
                                                             :end_date => params[:tagging][:end_date],
                                                             :comments => params[:tagging][:comments])
    if @tagging.save
      flash[:notice] = 'Tagging was successfully created.'
    end
    @person = Person.find(params[:person_id])
  end

  def edit
    @tagging = Tagging.find(params[:id])
  end

  def update
    @tagging = Tagging.find(params[:id])
    if @tagging.update_attributes(params[:tagging])
      flash[:notice] = 'Tagging was successfully updated.'
      redirect_to :action => 'show', :id => @tagging
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tagging.find(params[:id]).destroy
  end
end
