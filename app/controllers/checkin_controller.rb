class CheckinController < ApplicationController
  before_filter :authenticate_user!

  before_filter :set_cache_buster

include CheckinHelper

  def index
    @households = []
    if current_user.current_instance_preference?
      @instance = Instance.find(current_user.current_instance_preference)
    else
      @instance = Instance.current
    end
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
    @instance = current_user.current_instance_preference? ? current_user.current_instance_preference : nil
    @people.each do |person|
      attendance = person.checkin(instance_id: @instance)
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
    if current_user.current_instance_preference?
      @instance = Instance.find(current_user.current_instance_preference)
    else
      @instance = Instance.current
    end
  end
  
  def search
    @households = Household.where('name LIKE ? OR phones.number LIKE ? OR people.last_name LIKE ?', params[:search][:q], "%"+params[:search][:q], params[:search][:q]).includes(:phones).joins(:people)
    if @households.empty?
      flash[:blue] = "No results. Please try your search again."
    end
    if current_user.current_instance_preference?
      @current_instance = Instance.find(current_user.current_instance_preference)
    else
      @current_instance = Instance.current
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
    # if current_user.current_instance_preference?
    #   @instance = Instance.find(current_user.current_instance_preference)
    #   flash[:alert] = "This station is temporarily checking into #{@instance.event.name}, #{@instance.instance_type.name}"
    # end
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
    if current_user.current_instance_preference?
      @current_instance = Instance.find(current_user.current_instance_preference)
    else
      @current_instance = Instance.current
    end
  end
  
  private
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  
end
