class MeetingsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_meeting, only: [:show, :edit, :update, :destroy, :checkout_all, :undo_all, :set_checkin_code, :random_person_from, :kiosk]
  
  respond_to :html, :js

  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.load
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
    @instance = Instance.find(params[:instance_id])
    @groups = @instance.available_groups
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @instance = Instance.find(params[:meeting][:instance_id])
    @meeting = Meeting.new(meeting_params)
    @groups = @instance.available_groups
    if @meeting.save
      flash[:notice] = "New meeting successfully added."
      @object = @meeting.instance
    end
    respond_with( @meeting, layout: !request.xhr? )
  end

  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
        format.html { redirect_to @meeting, notice: 'Meeting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting.destroy
    respond_to do |format|
      format.html { redirect_to meetings_url }
      format.json { head :no_content }
    end
  end
  
  def checkout_all
    @meeting.attendances.un_checked_out.each do |a|
      a.checkout
    end
    flash[:notice] = "Everyone in the meeting has been checked out."
    redirect_to @meeting
  end
  
  def undo_all
    @meeting.attendances.destroy_all
    flash[:notice] = "All Checkins have been deleted... as if no one ever showed up."
    redirect_to @meeting
  end
  
  def set_checkin_code
    if @meeting.checkin_code.present?
      flash[:info] = "This meeting already has a checkin code."
    else
      @meeting.set_checkin_code
      if @meeting.save
        flash[:notice] = "Checkin code has been set."
      else
        flash[:error] = "Could not set checkin code. Try again."
      end
    end
    redirect_to @meeting
  end
  
  def random_person_from
    id = @meeting.attendances.collect {|a| a.person_id}.sample
    @person = Person.find(id)
  end
  
  def kiosk
    @results = []
    @by = "Name"
    @pad = "alpha_keyboard"
    @search = ""
    session[:sign_up_step] = session[:sign_up_params] = nil
    render(layout: 'self_checkin')
  end
  
  def search
    @meeting = Meeting.find(params[:meeting_id])
    @results = @meeting.group.people.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:terms]}%", "%#{params[:terms]}%")
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
    @meeting = Meeting.find(params[:meeting_id])
    if @search == ""
      @results = []
    else
      @results = @meeting.group.people.where('first_name LIKE ? OR last_name LIKE ?', "%#{@search}%", "%#{@search}%").order('last_name, first_name ASC')
    end
  end
  
  def checkin
    @meeting = Meeting.find(params[:meeting_id])
    @person = Person.find(params[:person_id])
    attendance = @person.checkin(instance_id: @meeting.instance.id, group_id: @meeting.group.id)
    if attendance.persisted?
      flash[:notice] = "You have been checked in!"
    else
      flash[:error] = "Sorry, you couldn't be checked in: #{attendance.errors.full_messages.to_sentence}."
    end
    redirect_to kiosk_meeting_path(@meeting)
  end
  
  def sign_up
    @meeting = Meeting.find(params[:id])
  end
  
  def new_person
    @meeting = Meeting.find(params[:id])
    @group = @meeting.group
    if params[:person][:first_name].present? && params[:person][:last_name].present? && params[:person][:gender].present?
      paramaters = {
        household: {
          name: "#{@group.name} Guest",
          address1: '2900 Douglas',
          address2: '',
          city: 'Bossier City',
          state: 'LA',
          zip: '71111',
          people_attributes: [
            { 
              first_name: params[:person][:first_name],
              last_name: params[:person][:last_name],
              gender: params[:person][:gender],
              default_group_id: @group.id
              }
            ]
        }
      }
      @household = Household.create(paramaters[:household])
      @person = @household.people.where(first_name: params[:person][:first_name]).first
      if @person
        @e = @person.enroll!(@group)
        if @e == true
          flash[:notice] = "Your account was created and you have been enrolled into this meeting's group. You may now checkin."
        else
          flash[:error] = "Youru account was created, but we couldn't enroll you into this meeting's group. I give up."
        end
      else
        flash[:error] = "I'm sorry, your account couldn't be created. Please try again."
      end
    else
      flash[:error] = "Your account could not be created. Please try again."
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_params
      params.require(:meeting).permit(:instance_id, :group_id, :room_id, :real_date, :comments, :num_marked)
    end
end
