class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin
  
  before_action :set_setting, only: [:show, :edit, :update, :destroy, :lock, :unlock, :change, :set]
  
  def index
    @settings = Setting.all
  end
  
  def new
    @setting = Setting.new
  end
  
  def create
    @setting = Setting.new(setting_params)
 
    if @setting.save
      respond_to do |format|
        format.json { render :json => @setting.to_json, :status => 200 }
        format.xml  { head :ok }
        format.html { redirect_to admin_settings_url, notice: "Setting was successfully created" }
      end
    else
      respond_to do |format|
        format.json { render :text => "Could not create setting", :status => :unprocessable_entity } # placeholder
        format.xml  { head :ok }
        format.html { render :action => :new, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    
  end
  
  def edit
  end
  
  def change
    
  end
  
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to admin_settings_url, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def set
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to admin_setting_path(@setting), notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
    if @setting.destroy
      flash[:notice] = "Setting was successfully destroyed."
    else
      flash[:error] = "The setting could not be destroyed."
    end
    redirect_to admin_settings_url
  end
  
  private
  
  def set_setting
    @setting = Setting.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def setting_params
    params.require(:setting).permit(:key, :key_is, :value, :field_type, :locked_at, :id)
  end
  
  def verify_admin
    unless current_user.admin?
      flash[:error] = "You are not allowed to access this page."
      redirect_to root_url
    end
  end
  
  
end
