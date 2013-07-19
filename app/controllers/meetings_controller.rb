class MeetingsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_meeting, only: [:show, :edit, :update, :destroy, :checkout_all, :undo_all, :set_checkin_code]
  
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
    @meeting.set_checkin_code
    if @meeting.save
      flash[:notice] = "Checkin code has been set."
    else
      flash[:error] = "Could not set checkin code. Try again."
    end
    redirect_to @meeting
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
