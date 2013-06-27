class LeadershipsController < ApplicationController
  before_action :set_leadership, only: [:show, :edit, :update, :destroy]

  # GET /leaderships
  # GET /leaderships.json
  def index
    @leaderships = Leadership.all
  end

  # GET /leaderships/1
  # GET /leaderships/1.json
  def show
  end

  # GET /leaderships/new
  def new
    @leadership = Leadership.new
  end

  # GET /leaderships/1/edit
  def edit
  end

  # POST /leaderships
  # POST /leaderships.json
  def create
    @leadership = Leadership.new(leadership_params)

    respond_to do |format|
      if @leadership.save
        format.html { redirect_to @leadership, notice: 'Leadership was successfully created.' }
        format.json { render action: 'show', status: :created, location: @leadership }
      else
        format.html { render action: 'new' }
        format.json { render json: @leadership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leaderships/1
  # PATCH/PUT /leaderships/1.json
  def update
    respond_to do |format|
      if @leadership.update(leadership_params)
        format.html { redirect_to @leadership, notice: 'Leadership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @leadership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leaderships/1
  # DELETE /leaderships/1.json
  def destroy
    @leadership.destroy
    respond_to do |format|
      format.html { redirect_to leaderships_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leadership
      @leadership = Leadership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leadership_params
      params.require(:leadership).permit(:leadable_id, :leadable_type, :type, :person_id, :title)
    end
end
