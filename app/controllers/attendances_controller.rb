class AttendancesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_attendance, only: [:show, :edit, :update, :destroy, :checkout, :child_sticker]

  # GET /attendances
  # GET /attendances.json
  def index
    @attendances = Attendance.page(params[:page]).all
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    @attendance = Attendance.new
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances
  # POST /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to @attendance, notice: 'Attendance was successfully created.' }
        format.json { render action: 'show', status: :created, location: @attendance }
      else
        format.html { render action: 'new' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: 'Attendance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    @meeting = @attendance.meeting
    @attendance.destroy
    flash[:notice] = "The checkin record was destoyed."
    respond_to do |format|
      format.html { redirect_to meeting_path(@meeting) }
      format.json { head :no_content }
    end
  end
  
  
  def checkout
    @attendance.checkout
    flash[:notice] = "#{@attendance.person.full_name} was checked out."
    redirect_to meeting_path(@attendance.meeting)
  end
  
  def child_sticker
    @attendances = [@attendance]
    render layout: 'sticker'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.require(:attendance).permit(:person_id, :meeting_id, :checkin_time, :checkout_time, :checkin_type_id, :security_code, :call_number)
    end
end
