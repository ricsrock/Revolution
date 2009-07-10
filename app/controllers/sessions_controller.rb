class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || Userr.count > 0
  end

  def login
    return unless request.post?
    self.current_userr = Userr.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_userr.remember_me
        cookies[:auth_token] = { :value => self.current_userr.remember_token , :expires => self.current_userr.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/sessions', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @userr = Userr.new(params[:userr])
    return unless request.post?
    @userr.save!
    self.current_userr = @userr
    redirect_back_or_default(:controller => '/sessions', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_userr.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/sessions', :action => 'index')
  end
end
