class PreferencesController < ApplicationController
  
  
  def edit_fav_instance
    @instances = Instance.future
  end
  
  def set_fav_instance
    if params[:fav_instance_id]
      current_user.set_preference!(:fav_instance_id, params[:fav_instance_id].first)
      current_user.set_preference!(:fav_instance_set_on, Date.today.to_s(:db))
      flash[:notice] = "Your Instance preference has been set until midnight tonight, then it will expire."
    else
      flash[:error] = "You didn't select a Service Instance. No preference was set."
    end
    redirect_to checkin_index_url
  end
  
  def clear_fav_instance
    current_user.set_preference!(:fav_instance_id, nil)
    current_user.set_preference!(:fav_instance_set_on, nil)
    flash[:notice] = "Your Instance preference has been cleared."
    redirect_to checkin_index_url
  end
end
