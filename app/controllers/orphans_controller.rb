class OrphansController < ApplicationController
  def people
    @people = Person.where("household_id IS NULL OR household_id = ''")
  end
  
  def edit_household
    @person = Person.find(params[:id])
  end
end
