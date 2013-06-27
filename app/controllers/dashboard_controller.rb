class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  skip_authorize_resource
  
  def index
    
  end
end
