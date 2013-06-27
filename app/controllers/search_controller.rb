class SearchController < ApplicationController
  before_filter :authenticate_user!
  
  def do
    if params[:q].blank?
      params[:q] = "xxxzxzxzzzxzxzxzxz"
    end
    q = "%#{params[:q]}%"
    names = params[:q].gsub(",", " ").split(' ')
    if names.length == 1
      conditions = ["last_name LIKE ? OR first_name LIKE ? OR emails.email LIKE ?", "%#{names[0].strip}%", "%#{names[0].strip}%", q]
    elsif names.length >= 2
      conditions = ["last_name LIKE ? AND first_name LIKE ? OR (first_name LIKE ? AND last_name LIKE ?) OR emails.email LIKE ?", "%#{names[0].strip}%", "%#{names[1].strip}%", "%#{names[0].strip}%", "%#{names[1].strip}%", q]
    end
    @results = []
    Person.where(conditions)
          .includes(:emails).order('last_name, first_name ASC').limit(10).references(:emails).to_a.each do |person|
      @results << person
    end
    Household.where('name LIKE ? OR emails.email LIKE ?', q, q)
             .includes(:emails).order(:name).limit(10).references(:emails).to_a.each do |household|
      @results << household
    end
    Group.where('name LIKE ?', q).order(:name).limit(10).to_a.each do |group|
      @results << group.becomes(Group)
    end
    Organization.where('name LIKE ? OR emails.email LIKE ?', q, q)
             .includes(:emails).order(:name).limit(10).references(:emails).to_a.each do |organization|
      @results << organization
    end
    @results
    respond_to do |format|
      format.js
    end
  end
end
