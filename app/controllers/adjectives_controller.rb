class AdjectivesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_adjective, only: [:show, :edit, :update, :destroy]

  # GET /adjectives
  # GET /adjectives.json
  def index
    @adjectives = Adjective.all
  end

  # GET /adjectives/1
  # GET /adjectives/1.json
  def show
  end

  # GET /adjectives/new
  def new
    @adjective = Adjective.new
  end

  # GET /adjectives/1/edit
  def edit
  end

  # POST /adjectives
  # POST /adjectives.json
  def create
    @adjective = Adjective.new(adjective_params)

    respond_to do |format|
      if @adjective.save
        format.html { redirect_to @adjective, notice: 'Adjective was successfully created.' }
        format.json { render action: 'show', status: :created, location: @adjective }
      else
        format.html { render action: 'new' }
        format.json { render json: @adjective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adjectives/1
  # PATCH/PUT /adjectives/1.json
  def update
    respond_to do |format|
      if @adjective.update(adjective_params)
        format.html { redirect_to @adjective, notice: 'Adjective was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @adjective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjectives/1
  # DELETE /adjectives/1.json
  def destroy
    @adjective.destroy
    respond_to do |format|
      format.html { redirect_to adjectives_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adjective
      @adjective = Adjective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adjective_params
      params.require(:adjective).permit(:name, :updated_by, :created_by)
    end
end
