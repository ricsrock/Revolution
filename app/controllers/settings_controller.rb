class SettingsController < ApplicationController
  
  def index
    @setting = Setting.first || Setting.create
  end
  
end
