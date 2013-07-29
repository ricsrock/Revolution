class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin
  
  def index
  end
  
  def records
    @total_people = Person.all.size
    @total_households = Household.all.size
    @new_people = Person.where("created_at >= ?", Time.zone.now.beginning_of_week(:sunday))
    @new_households = Household.where("created_at >= ?", Time.zone.now.beginning_of_week(:sunday))
  end
  
  def stats
    @batches_this_week = Batch.where('date_collected >= ? AND date_collected <= ?', do_range('This Week').start_date.to_time.to_s(:db), do_range('This Week').end_date.to_time.to_s(:db))
    @income_this_week = @batches_this_week.collect {|b| b.amount_recorded}.sum
    @events_this_week = Event.where('date >= ? AND date <= ?', do_range('This Week').start_date.to_s(:db), do_range('This Week').end_date.to_s(:db))
    @attendances_this_week = @events_this_week.collect {|v| v.attendances}.sum
  end
end