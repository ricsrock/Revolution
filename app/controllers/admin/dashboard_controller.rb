class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin
  
  def index
    @total_people = Person.all.size
    @total_households = Household.all.size
    @new_people = Person.where("created_at >= ?", Time.zone.now.beginning_of_week(:sunday))
    @new_households = Household.where("created_at >= ?", Time.zone.now.beginning_of_week(:sunday))
  end
end