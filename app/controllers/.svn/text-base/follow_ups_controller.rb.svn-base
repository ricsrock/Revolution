class FollowUpsController < ApplicationController
    
    before_filter :login_required

      require_role ["checkin_user", "supervisor"]
      require_role "admin", :only => [:executive]
    
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @follow_up_pages, @follow_ups = paginate :follow_ups, :per_page => 10
  end

  def show
    @follow_up = FollowUp.find(params[:id])
  end

  def new
    @follow_up = FollowUp.new
  end

  def create
    @follow_up = FollowUp.new(params[:follow_up])
    if @follow_up.save
      flash[:notice] = 'FollowUp was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @follow_up = FollowUp.find(params[:id])
  end

  def update
    @follow_up = FollowUp.find(params[:id])
    if @follow_up.update_attributes(params[:follow_up])
      flash[:notice] = 'FollowUp was successfully updated.'
      redirect_to :action => 'show', :id => @follow_up
    else
      render :action => 'edit'
    end
  end

  def destroy
    @follow_up = FollowUp.find(params[:id])
    @contact = @follow_up.contact
    if current_user.authorized_for_follow_up?(@follow_up)
      if @follow_up.destroy
        flash[:notice] = "Follow-Up was permanently destroyed."
      end
    else
      flash[:notice] = "You are not authorized to delete a follow-up that you didn't create."
    end
    redirect_to :controller => 'contacts', :action => 'follow_up', :id => @contact
  end
  
  def manage
    @follow_ups = current_user.recent_follow_ups
    session[:uri] = request.request_uri
  end
  
  def executive
    @follow_ups = FollowUp.find(:all, :conditions => ["created_at > ?", (Time.now - 45.days)])
    session[:uri] = request.request_uri
  end
  
  def search_follow_ups
    if params[:user]
        user_result = params[:user][:login]
    else
        user_result = current_user.login
    end
    range_result = params[:follow_up][:range]
    type_result = params[:follow_up][:type]
    attribution = params[:follow_up][:attribution]
    contact_type_result = params[:follow_up][:contact_type_id]
    @follow_ups = FollowUp.find_by_ez_where(range_result,type_result,attribution,user_result,contact_type_result)
  end
end
