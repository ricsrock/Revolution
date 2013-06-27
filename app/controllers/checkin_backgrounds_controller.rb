class CheckinBackgroundsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource
  before_action :set_checkin_background, only: [:show, :edit, :update, :destroy, :favorite]

  # GET /checkin_backgrounds
  # GET /checkin_backgrounds.json
  def index
    @checkin_backgrounds = CheckinBackground.all
  end

  # GET /checkin_backgrounds/1
  # GET /checkin_backgrounds/1.json
  def show
  end

  # GET /checkin_backgrounds/new
  def new
    @checkin_background = CheckinBackground.new
  end

  # GET /checkin_backgrounds/1/edit
  def edit
  end
  
  def favorite
    current_user.set_preference!(:favorite_checkin_background_id, @checkin_background.id)
    flash[:notice] = "Your favorite Checkin Background has been set!"
    redirect_to checkin_backgrounds_url
  end

  # POST /checkin_backgrounds
  # POST /checkin_backgrounds.json
  def create
    @checkin_background = CheckinBackground.new(checkin_background_params)

    respond_to do |format|
      if @checkin_background.save
        format.html { redirect_to @checkin_background, notice: 'Checkin background was successfully created.' }
        format.json { render action: 'show', status: :created, location: @checkin_background }
      else
        format.html { render action: 'new' }
        format.json { render json: @checkin_background.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /checkin_backgrounds/1
  # PATCH/PUT /checkin_backgrounds/1.json
  def update
    respond_to do |format|
      if @checkin_background.update(checkin_background_params)
        format.html { redirect_to @checkin_background, notice: 'Checkin background was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @checkin_background.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checkin_backgrounds/1
  # DELETE /checkin_backgrounds/1.json
  def destroy
    @checkin_background.destroy
    respond_to do |format|
      format.html { redirect_to checkin_backgrounds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkin_background
      @checkin_background = CheckinBackground.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkin_background_params
      params.require(:checkin_background).permit(:name, :graphic)
    end
end
