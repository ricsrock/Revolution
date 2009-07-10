class ServiceLinksController < ApplicationController
 
    before_filter :login_required
 
 
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @service_link_pages, @service_links = paginate :service_links, :per_page => 10
  end

  def show
    @service_link = ServiceLink.find(params[:id])
  end

  def new
    @service_link = ServiceLink.new
  end

  def create
    @service_link = ServiceLink.new(:group_id => params[:group_id], :team_id => params[:team][:id])
    if @service_link.save
      flash[:notice] = 'ServiceLink was successfully created.'
    end
    @group = Group.find(params[:group_id])
  end

  def edit
    @service_link = ServiceLink.find(params[:id])
  end

  def update
    @service_link = ServiceLink.find(params[:id])
    if @service_link.update_attributes(params[:service_link])
      flash[:notice] = 'ServiceLink was successfully updated.'
      redirect_to :action => 'show', :id => @service_link
    else
      render :action => 'edit'
    end
  end

  def destroy
    ServiceLink.find(params[:id]).destroy
    @group = Group.find(params[:group_id])
  end
end
