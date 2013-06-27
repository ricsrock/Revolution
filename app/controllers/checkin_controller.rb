class CheckinController < ApplicationController
  before_filter :authenticate_user!

include CheckinHelper

  def index
    @households = []
  end
  
  def checkin_selected
    @referrer = URI(request.referrer).path
    logger.info "referrer is: #{@referrer}"
    @people = Person.where('id IN (?)', params[:person_check])
    @true = []
    @false = []
    @errors = []
    @success_people_ids = []
    @attendances = []
    @people.each do |person|
      attendance = person.checkin
      if attendance.persisted?
        @true << attendance.person.full_name
        @success_people_ids << person.id
        @attendances << attendance
        logger.info "---------- attendance is persisted"
      else
        logger.info "------------ attendance is NOT persisted"
        @false << attendance
        #print sticker...
      end
    end
    flash[:notice] = "#{success_names(@true)}" unless @true.empty?
    # flash[:error] = "#{fail_names(@false)}" unless @false.empty?
    unless @false.empty?
      logger.info " ----------- false is NOT empty"
      flash[:error] = ""
      logger.info "-------- flash[:error] = #{flash[:error]}"
      @false.each do |attendance|
        flash[:error] << "#{attendance.person.full_name} was not checked in with the following error(s): #{attendance.errors.full_messages.to_sentence}. \n"
      end
    end
    #flash[:blue] = @errors
    @households = []
    logger.info "households set to #{@households}"
    @pad = "num_pad"
    @by = "Phone Number (last 4)"
  end
  
  def search
    @households = Household.where('name LIKE ? OR phones.number LIKE ? OR people.last_name LIKE ?', params[:search][:q], "%"+params[:search][:q], params[:search][:q]).includes(:phones).joins(:people)
    if @households.empty?
      flash[:blue] = "No results. Please try your search again."
    end
  end
  
  def key_pressed
    if params[:key] == "Backspace" or params[:key] == "<"
      @search = params[:search].chop
    elsif params[:key] == "Clear"
      @search = ""
    else
      @search = params[:search] << params[:key]
    end
    @pad = params[:pad]
  end
  
  def print_label
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def self
    @by = "Phone Number (last 4)"
    @pad = "num_pad"
    @search = ""
    render(layout: 'self_checkin')
  end
  
  def search_choice
    if params[:search_choice] == "last_name"
      @by = "Last Name"
      @pad = "alpha_keyboard"
    else
      @by = "Phone Number (last 4)"
      @pad = "num_pad"
    end
  end
  
  def search_self
    term = params[:terms]
    term.blank? ? term = "xxxxxxxzzzzzzzzzxxxxxxxx" : term
    @households = Household.where('name LIKE ? OR phones.number LIKE ?', term, '%' + term).includes(:phones)
  end
  
end
