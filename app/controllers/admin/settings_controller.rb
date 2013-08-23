class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin
  
  def index
    @settings = Setting.all
  end
  
  def new
    @setting = Setting.new
  end
  
end
