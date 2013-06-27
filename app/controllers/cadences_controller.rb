class CadencesController < ApplicationController
  before_action :set_cadence, only: [:show, :edit, :update, :destroy]

  # GET /cadences
  # GET /cadences.json
  def index
    @cadences = Cadence.all
  end

  # GET /cadences/1
  # GET /cadences/1.json
  def show
  end

  # GET /cadences/new
  def new
    @cadence = Cadence.new
  end

  # GET /cadences/1/edit
  def edit
  end

  # POST /cadences
  # POST /cadences.json
  def create
    @cadence = Cadence.new(cadence_params)

    respond_to do |format|
      if @cadence.save
        format.html { redirect_to @cadence, notice: 'Cadence was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cadence }
      else
        format.html { render action: 'new' }
        format.json { render json: @cadence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cadences/1
  # PATCH/PUT /cadences/1.json
  def update
    respond_to do |format|
      if @cadence.update(cadence_params)
        format.html { redirect_to @cadence, notice: 'Cadence was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cadence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cadences/1
  # DELETE /cadences/1.json
  def destroy
    @cadence.destroy
    respond_to do |format|
      format.html { redirect_to cadences_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cadence
      @cadence = Cadence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cadence_params
      params.require(:cadence).permit(:name)
    end
end
