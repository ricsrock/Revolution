class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  before_filter :set_the_user
  # check_authorization :unless => :devise_controller?
  rescue_from ActiveRecord::DeleteRestrictionError do |exception|
    flash[:error] = "You can't delete that record because other records reference it."
    redirect_to :back
  end
  
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.js   { render :template => 'dashboard/access_denied', :alert => exception.message }
    end
  end
  
  protected
  
  def verify_admin
    unless current_user.admin?
      flash[:error] = "You are not allowed to access this page."
      redirect_to root_url
    end
  end
  
  def set_the_user
    User.the_user = current_user
  end
  
end
