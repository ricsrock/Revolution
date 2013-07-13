class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy, :confirm, :unconfirm]
  
  
  def index
    @q = User.page(params[:page]).search(params[:q])
    @users = @q.result(distinct: true)
  end
  
  def new
    @user = User.new
  end
  
  def show
  end
  
  def edit
  end
  
  def create
    @user = User.new(user_params)
 
    if @user.save
      respond_to do |format|
        format.json { render :json => @user.to_json, :status => 200 }
        format.xml  { head :ok }
        format.html { redirect_to :action => :index, notice: "User was successfully created" }
      end
    else
      respond_to do |format|
        format.json { render :text => "Could not create user", :status => :unprocessable_entity } # placeholder
        format.xml  { head :ok }
        format.html { render :action => :new, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    if params[:user][:password].blank?
      [:password,:password_confirmation,:current_password].collect{|p| params[:user].delete(p) }
    else
      @user.errors[:base] << "The passwords you entered do not match" unless params[:user][:password] == params[:user][:password_confirmation]
    end
 
    respond_to do |format|
      if @user.errors[:base].empty? and @user.update_attributes(user_params)
        flash[:notice] = "Your account has been updated"
        format.json { render :json => @user.to_json, :status => 200 }
        format.xml  { head :ok }
        format.html { redirect_to admin_user_path(@user) }
      else
        flash[:alert] = "#{@user.errors.full_messages.collect {|m| m}.to_sentence}"
        format.json { render :text => "Could not update user", :status => :unprocessable_entity } #placeholder
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.html { render :action => :edit, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user.destroy
    
    redirect_to admin_users_url
  end
  
  def confirm
    @user.confirm!
    redirect_to :back, notice: "User has been confirmed and can now login"
  end
  
  def unconfirm
    if @user.unconfirm!
      flash[:notice] = "The user has been successfully deactivated."
    else
      flash[:alert] = "The user could not be de-activated: #{@user.errors.full_messages.collect {|m| m}.to_sentence}"
    end
    redirect_to :back
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :login, :email, :password, :password_confirmation, :is_staff, :person_name, role_ids: [])
  end
  
  def verify_admin
    unless current_user.admin?
      flash[:error] = "You are not allowed to access this page."
      redirect_to root_url
    end
  end
  
  
  
end
