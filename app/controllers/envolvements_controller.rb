class EnvolvementsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_envolvement, only: [:show, :edit, :update, :destroy]

  # GET /envolvements
  # GET /envolvements.json
  def index
    @envolvements = Envolvement.all
  end

  # GET /envolvements/1
  # GET /envolvements/1.json
  def show
  end

  # GET /envolvements/new
  def new
    @envolvement = Envolvement.new
  end

  # GET /envolvements/1/edit
  def edit
  end

  # POST /envolvements
  # POST /envolvements.json
  def create
    @envolvement = Envolvement.new(envolvement_params)

    respond_to do |format|
      if @envolvement.save
        format.html { redirect_to @envolvement, notice: 'Envolvement was successfully created.' }
        format.json { render action: 'show', status: :created, location: @envolvement }
      else
        format.html { render action: 'new' }
        format.json { render json: @envolvement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /envolvements/1
  # PATCH/PUT /envolvements/1.json
  def update
    respond_to do |format|
      if @envolvement.update(envolvement_params)
        format.html { redirect_to @envolvement, notice: 'Envolvement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @envolvement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /envolvements/1
  # DELETE /envolvements/1.json
  def destroy
    @envolvement.destroy
    respond_to do |format|
      format.html { redirect_to envolvements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_envolvement
      @envolvement = Envolvement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def envolvement_params
      params[:envolvement]
    end
end
