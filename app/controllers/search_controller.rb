class SearchController < ApplicationController
  
  def do
    if params[:q].blank?
      params[:q] = "xxxzxzxzzzxzxzxzxz"
    end
    q = "%#{params[:q]}%"
    @results = []
    Person.where('last_name LIKE ? OR first_name LIKE ?', q, q).all.each do |person|
      @results << person
    end
    Household.where('name LIKE ?', q).all.each do |household|
      @results << household
    end
    Group.where('name LIKE ?', q).all.each do |group|
      @results << group
    end
    respond_to do |format|
      format.js
    end
  end
end
