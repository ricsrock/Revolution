class MeetingTimesController < ApplicationController
  before_action :set_meeting_time, only: [:show, :edit, :update, :destroy]

  # GET /meeting_times
  # GET /meeting_times.json
  def index
    @meeting_times = MeetingTime.all
  end

  # GET /meeting_times/1
  # GET /meeting_times/1.json
  def show
  end

  # GET /meeting_times/new
  def new
    @meeting_time = MeetingTime.new
  end

  # GET /meeting_times/1/edit
  def edit
  end

  # POST /meeting_times
  # POST /meeting_times.json
  def create
    @meeting_time = MeetingTime.new(meeting_time_params)

    respond_to do |format|
      if @meeting_time.save
        format.html { redirect_to @meeting_time, notice: 'Meeting time was successfully created.' }
        format.json { render action: 'show', status: :created, location: @meeting_time }
      else
        format.html { render action: 'new' }
        format.json { render json: @meeting_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meeting_times/1
  # PATCH/PUT /meeting_times/1.json
  def update
    respond_to do |format|
      if @meeting_time.update(meeting_time_params)
        format.html { redirect_to @meeting_time, notice: 'Meeting time was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @meeting_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meeting_times/1
  # DELETE /meeting_times/1.json
  def destroy
    @meeting_time.destroy
    respond_to do |format|
      format.html { redirect_to meeting_times_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting_time
      @meeting_time = MeetingTime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_time_params
      params.require(:meeting_time).permit(:time)
    end
end
