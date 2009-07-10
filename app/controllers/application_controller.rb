# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  before_filter :set_current_user
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  include ExceptionNotifiable
  include RedirectCode

  #audit User, Person

  #model :group_choice
  
  helper :date
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_revolution_session_id'
  
  alias :rescue_action_locally :rescue_action_in_public
  
  protected

  def set_current_user
    User.current_user = self.current_user
  end
  
# def current_user
#   @user ||= User.find(session[:user])
# end
  
 
end
