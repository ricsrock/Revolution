class SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @setting = Setting.first || Setting.create
  end
  
end
