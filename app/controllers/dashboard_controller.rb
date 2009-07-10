class DashboardController < ApplicationController
  
  before_filter :login_required
  
  require_role [:checkin_user, :supervisor, :admin]
  
  layout 'application', :except => [:feed, :contact_type_feed]
  
  def index
      cookies.delete :portlet
  end
  
end
