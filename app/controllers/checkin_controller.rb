class CheckinController < ApplicationController

include CheckinHelper

  def index
    @households = Household.limit(5)
  end
  
  def checkin_selected
    @people = Person.where('id IN (?)', params[:person_check])
    @true = []
    @false = []
    @people.each do |person|
      if person.checkin
        @true << person.full_name
      else
        @false << person.full_name
      end
    end
    flash[:notice] = "#{success_names(@true)} #{fail_names(@false)}"
    redirect_to checkin_index_url
  end
  
  def search
    @households = Household.where('name LIKE ? OR phones.number LIKE ? OR people.last_name LIKE ?', params[:search][:q], "%"+params[:search][:q], params[:search][:q]).includes(:phones).joins(:people)
  end
  
end
